## Setting up the Environment on Google Cloud
### 1. Generate SSH keys to login to VM instances
    (https://cloud.google.com/compute/docs/connect/create-ssh-keys)
\
    ```
    $ cd ~/.ssh
    $ ssh-keygen -t rsa -f ~/.ssh/gcp -C albert_tests -b 2048
    ```
    > pass: empty

### 2. Put generated public key to google cloud:
    (Metadata -> SSH Keys -> Add ssh key) and copy all from file `gcp.pub`

### 3. Create Virtual Machine Instance (Compute Engine -> VM Instances -> Create Instance).
    ```
    Name: de-zoomcamp
    Region: us-east1-b
    Machine type: e2-standard-4
    Operating system: Ubuntu
    Version: Ubuntu 20.04 LTS
    Boot disk size: 30Gb.
    ```    

### 4. Connect to created VM from terminal (Copy an external ip of created VM): 
    ```
    $ ssh -i ~/.ssh/gcp albert_tests@<external_ip_you_copied>
    ```
   `htop` to see info about VM
   
- Download anaconda into VM:
   ```
   $ wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
   ```
-   Install Anaconda:
   ```
   $ bash Anaconda3-2022.10-Linux-x86_64.sh
   ```

### 5. Create a config file for SSH (config access to ssh server).
   ```
   $ cd ~/.ssh/
   # Create config file (or open if exists)
   $ touch config
   ```
   Add:
   ```
   Host de-zoomcamp
    Hostname <external_ip_you_copied>
    User albert_tests
    IdentityFile ~/.ssh/gcp
   ```
   Then you can run `ssh de-zoomcamp` to connect to this VM.
   
### 6.  Config Visual Studio Code (Remote SSH plugin) or PyCharm to connect by ssh to VM instance.

### 7. Install docker in VM:
    ```
    $ sudo apt-get install docker.io
    ```

### 8. Clone my github course repo into VM instance:
    ```
    $ git clone https://github.com/DreadYo/data-engineering-zoomcamp.git
    ```

### 9. Give permission to run docker commands without sudo in VM:
    (https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md)


- Add the `docker` group if it doesn't already exist
    ```
    $ sudo groupadd docker
    ```

- Add the connected user `$USER` to the docker group

    Optionally change the username to match your preferred user.
    ```console
    $ sudo gpasswd -a $USER docker
    ```

    **IMPORTANT**: Log out and log back in so that your group membership is re-evaluated.

- Restart the `docker` daemon
    ```console
    $ sudo service docker restart
    ```

    If you are on Ubuntu 14.04-15.10, use `docker.io` instead:
    ```console
    $ sudo service docker.io restart
    ```

- Check if docker works:
    ```console
    $ docker run hello-world
    ```

### 10. Install docker-compose:
    (https://github.com/docker/compose)

- Find installation for linux-x86_64:
    (https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64)

- In main folder create new dir for executable files `bin`:
    ```
    $ mkdir bin
    ```
- In dir `bin` run:
    ```
    $ wget https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -O docker-compose
    ```
- Make file `docker-compose` executable for system:
    ```
    $ chmod +x docker-compose
    ```
- Make `docker-compose` visible from any directory (edit PATH variable):
    ```
    $ nano .bashrc
    ```
  Add to the end:
    ```
    export PATH="${HOME}/bin:${PATH}"
    ```
  To relate it (or log out/log in):
    ```
    $ source .bashrc
    ```
  Now you can run without whole path:
`$ docker-compose version`

### 11. Run Postgres and PgAdmin using docker-compose:
- Go to `~/data-engineering-zoomcamp/week_1_basics_n_setup/docker_sql`
- Run: `$ docker-compose up -d`

### 11. Install pgcli:
- In home directory: `pip install pgcli`
- Log in into db: `$ pgcli -h localhost -U root -d ny_taxi`

    If it doesn't work, then: 
    ```
    $ conda install -c conda-forge pgcli
    $ pip install -U mycli
    ```

### 13. Setup port forwarding to local machine (to interact with Postgres instance locally):
- In Visual Studio Code (or PyCharm Pro) add port **5432** and **8080** for forwarding
- Then you can connect to Postgres from local machine:
    ```
    $ pgcli -h localhost -U root -d ny_taxi
    ```
    or
    ```
    $ pgcli -h 127.0.0.1 -U root -d ny_taxi
    ```
- And you can connect to PgAdmin from local machine in browser:
`http://localhost:8080`

### 14. Run Jupyter:



   


