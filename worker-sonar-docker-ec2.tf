resource "aws_instance" "sonar-ec2" {
  ami           = data.aws_ami.example.id
  instance_type = var.instance_type_sonar
  key_name      = "project-killi"

  vpc_security_group_ids = [aws_security_group.sonar_sg.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data              = <<-EOF
#!/bin/bash

# Update package lists
sudo apt-get update -y
#Create any server with at least minimum of 2 GB of RAM
#Install Java
# Create the SonarQube directory if it doesn't exist
sudo mkdir -p /opt/sonarqube

# Install Java
sudo apt-get install openjdk-17-jdk -y

# Download SonarQube zip file
cd /opt/sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.4.87374.zip

# Install unzip utility
sudo apt-get install unzip -y

# Unzip SonarQube zip file
unzip sonarqube-9.9.4.87374.zip
# Remove the zip file after extraction
rm sonarqube-9.9.4.87374.zip

# Now remember, SonarQube cannot be started with the root user. Let's create the SONARADMIN user to run SonarQube.
# Create the sonaradmin user
sudo useradd -s /bin/bash sonaradmin
sudo adduser sonaradmin sonaradmin

# Change ownership of the SonarQube directory and its contents to the sonaradmin user
sudo chown -R sonaradmin:sonaradmin /opt/sonarqube

# Start SonarQube
sudo -u sonaradmin /opt/sonarqube/sonarqube-9.9.4.87374/bin/linux-x86-64/sonar.sh start

# Open port 9000 for SonarQube
# IP:9000

EOF
}