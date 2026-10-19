{
  hjem-lib,
  lib,
  pkgs,
  config,
  ...
}:
let
  bus_socket = "unix:path=$XDG_RUNTIME_DIR/bus";
in
{
  hjem.users.vitrial.dinit.services = {
    pipewire = {
      type = "process";
      command = "${lib.getExe' config.programs.pipewire.package "pipewire"}";
      restart = true;
      depends-ms = [ "login.target" ];
    };
    pipewire-pulse = {
      type = "process";
      command = "${lib.getExe' config.programs.pipewire.package "pipewire-pulse"}";
      restart = true;
      prepared-by = [ "pipewire" ];
    };
    wireplumber = {
      # enable = false;
      type = "process";
      command = "${lib.getExe' config.programs.wireplumber.package "wireplumber"}";
      restart = true;
      prepared-by = [ "pipewire-pulse" ];
    };
    easyeffects = {
      type = "process";
      command = "${lib.getExe' pkgs.easyeffects "easyeffects"} --service-mode -w";
      restart = true;
      depends-on = [ "wireplumber" ];
    };

    dbus-session = {
      type = "process";
      command = "${lib.getExe' pkgs.dbus "dbus-daemon"} --session --address=${bus_socket}";
      restart = true;
      before = [ "login.target" ];
    };

    dbus-session-address = {
      type = "scripted";
      command = "${lib.getExe' pkgs.dinit "dinitctl"} setenv DBUS_SESSION_BUS_ADDRESS=${bus_socket}";
      depends-on = [ "dbus-session" ];
    };
  };

  finit.tasks =
    let
      inherit (hjem-lib) fileToJson;
      inherit (builtins) attrValues toJSON;
      inherit (lib.trivial) flip pipe;
      inherit (lib) getExe;
      oldManifests = "/var/lib/hjem";
      userFiles = user: [
        user.files
        user.xdg.cache.files
        user.xdg.config.files
        user.xdg.data.files
        user.xdg.state.files
      ];
      newManifests =
        let
          writeManifest =
            user:
            let
              name = "manifest-${user.user}.json";
            in
            pkgs.writeTextFile {
              inherit name;
              destination = "/${name}";
              text = toJSON {
                version = 3;
                files = lib.concatMap (flip pipe [
                  attrValues
                  (map fileToJson)
                ]) (userFiles config.hjem.users.vitrial);
              };
              checkPhase = ''
                set -e
                CUE_CACHE_DIR=$(pwd)/.cache
                CUE_CONFIG_DIR=$(pwd)/.config

                ${getExe pkgs.cue} vet -c ${./manifest-v3.cue} $target
              '';
            };
        in
        pkgs.symlinkJoin {
          name = "hjem-manifests";
          paths = lib.map writeManifest (attrValues (lib.filterAttrs (_: u: u.enable) config.hjem.users));
        };
    in
    {
      hjem-dinit-vitrial = {
        description = "Clean up dinit services for vitrial";
        user = "vitrial";
        log = true;
        conditions = [ "task/hjem-activate-vitrial/success" ];
        command =
          pkgs.writers.writeDash "hjem-dinit-vitrial.sh"
            {
              makeWrapperArgs = [
                "--prefix"
                "PATH"
                ":"
                "${lib.makeBinPath [
                  pkgs.jq
                  config.programs.coreutils.package
                  pkgs.dinit
                ]}"
              ];
            }
            ''
              # TODO find a better way to get XDG_RUNTIME_DIR for each user. probably gonna involve patching turnstiles backends...
              export XDG_RUNTIME_DIR=/run/user/1000

              new_manifest="${newManifests}/manifest-vitrial.json"
              old_manifest="${oldManifests}/manifest-vitrial.json"

              new_service_sources="$(jq -c '.files[]' "$new_manifest" | grep '/boot.d/' | jq -c '.source')"
              old_service_sources="$(jq -c '.files[]' "$old_manifest" | grep '/boot.d/' | jq -c '.source')"

              echo "New service sources:"
              echo "$new_service_sources"
              echo "Old service sources:"
              echo "$old_service_sources"

              for i in $new_service_sources; do
                i="$(echo "$i" | tr -d \")"
                i="''${i#"/nix/store/"}"

                service_name="$(echo "$i" | awk -F \- '{for (i=2; i<=(NF-1); i++) printf $i "-"; print $NF}')"

                new_hash="$(echo "$i" | awk -F \- '{print $1}')"

                old_hash="$(echo "$old_service_sources" | tr -d \" | grep "$service_name\$" | sed 's/\/nix\/store\///' | awk -F \- '{print $1}')"

                if [ "$old_hash" = "" ]; then
                  echo "Starting $service_name..."
                  dinitctl start "$service_name"
                  echo "Started $service_name"
                  set -- "$@" "$service_name"
                  continue
                fi

                if [ "$new_hash" != "$old_hash" ]; then
                  echo "$new_hash !="
                  echo "$old_hash"
                  echo "Reloading $service_name..."
                  dinitctl reload "$service_name"
                  dinitctl restart --force "$service_name"
                  echo "Done reloading $service_name"
                fi

                set -- "$@" "$service_name"
              done

              echo "Already did the following services: $@"
              echo "\n"

              for i in $old_service_sources; do
                i="$(echo "$i" | tr -d \")"
                i="''${i#"/nix/store/"}"

                service_name="$(echo "$i" | awk -F \- '{for (i=2; i<=(NF-1); i++) printf $i "-"; print $NF}')"

                SKIP=false

                for j in $@; do
                  if [ "$j" = "$service_name" ]; then
                    echo "$service_name already covered. skipping..."
                    SKIP="true"
                    break
                  fi
                done

                if [ "$SKIP" = "true" ]; then
                  continue
                fi

                echo "$service_name not already covered."

                echo "Stopping $service_name..."
                dinitctl stop --force "$service_name"
                echo "Stopped $service_name"
              done
            '';
      };

      hjem-copy-vitrial = {
        conditions = [
          "task/hjem-dinit-vitrial/success"
        ];
      };
    };
}
