## Setting up the Environment on Google Cloud
1. Generate SSH keys to login to VM instances
(https://cloud.google.com/compute/docs/connect/create-ssh-keys)
    ```
    cd ~/.ssh
    ssh-keygen -t rsa -f ~/.ssh/gcp -C albert_tests -b 2048
    ```
    > pass: empty
2. Put generated public key to google cloud:
(Metadata -> SSH Keys -> Add ssh key) abd copy all from file `gcp.pub`
3. Create Virtual Machine Instance (Compute Engine -> VM Instances -> Create Instance).
    ```text
    Name: de-zoomcamp
    Region: us-east1-b
    Machine type: e2-standard-4
    Operating system: Ubuntu
    Version: Ubuntu 20.04 LTS
    Boot disk size: 30Gb.
    ```    
4. Connect to created VM from terminal (Copy an external ip of created VM): 
    ```
    ssh -i ~/.ssh/gcp albert_tests@<external_ip_you_copied>
    ```
   `htop` to see info about VM
   
   Download anaconda into VM:
   ```
   wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
   ```
   Install Anaconda:
   ```
   bash Anaconda3-2022.10-Linux-x86_64.sh
   ```
5. Create a config file for SSH (config access to ssh server).
   ```
   cd ~/.ssh/
   # Create config file (or open if exists)
   touch config
   ```
   Add:
   ```
   Host de-zoomcamp
    Hostname <external_ip_you_copied>
    User albert_tests
    IdentityFile ~/.ssh/gcp
   ```
   Then you can run `ssh de-zoomcamp` to connect to this VM.
   
6.  Config Visual Studio Code (Remote SSh plugin) or PyCharm to connect by ssh to VM instance.

7. Install docker in VM:
    ```
    sudo apt-get install docker.io
    ```
8. Clone my github course repo into VM instance:
    ```
    git clone https://github.com/DreadYo/data-engineering-zoomcamp.git
    ```
   
   


