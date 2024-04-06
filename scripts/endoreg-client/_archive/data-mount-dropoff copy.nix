{pkgs}:

let
    mountpoint_parent_file = "/root/.secrets/hdd-mount-point-parent-dropoff";
    mapper_name_file = "/root/.secrets/hdd-mapper-name-dropoff"; # File containing the name of the mapper
    key_file = "/root/.secrets/hdd-key-dropoff"; # File containing the passphrase
    uuid_file = "/root/.secrets/hdd-uuid-dropoff"; # UUID of the encrypted partition
in

pkgs.writeShellScriptBin "mountDropOff" ''
    UUID=$(cat ${uuid_file})
    MOUNTPOINT_PARENT=$(cat ${mountpoint_parent_file})
    PASSPHRASE=$(cat ${key_file})
    MAPPER_NAME=$(cat ${mapper_name_file})
    MOUNTPOINT=$MOUNTPOINT_PARENT/$MAPPER_NAME

    # Prompt for passphrase
    PASSPHRASE=$(zenity --password --title="Decrypt and Mount DropOff")

    if [ -z "$PASSPHRASE" ]; then
        zenity --error --text="No passphrase provided. Exiting."
        exit 1
    fi

    # Decrypt the partition
    echo $PASSPHRASE | sudo cryptsetup open UUID=$UUID $MAPPER_NAME

    # Check if decryption was successful
    if [ $? -eq 0 ]; then
        # Create a mount point if it doesn't exist
        mkdir -p $MOUNTPOINT

        # Mount the file system
        sudo mount /dev/mapper/$MAPPER_NAME $MOUNTPOINT && zenity --info --text="DropOff mounted successfully"
    else
        zenity --error --text="Failed to decrypt or mount DropOff."
    fi

    # CHANGEME; SET PERMISSIONS AS NECESSARY IN PRODUCTION 
    sudo chmod -R 777 $MOUNTPOINT

  ''