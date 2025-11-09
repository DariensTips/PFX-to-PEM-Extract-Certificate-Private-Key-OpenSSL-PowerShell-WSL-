##############################################################
# Title :   	PFX to PEM: Extract Certificate Private Key | OpenSSL & PowerShell (WSL)
# Channel:		https://www.youtube.com/@darienstips9409
# Link:			https://www.youtube.com/watch?v=Flg4fD7hxdE
##############################################################


#### Export PFX 

Get-ChildItem Cert:\LocalMachine\my
$cert2Export=Get-ChildItem Cert:\LocalMachine\my\<thumbprint_here>
$myPass=ConvertTo-SecureString -Force -AsPlainText -string "mySup3rV#rY5tr0ngPsWRd" #don't use this in production!
Export-PfxCertificate -Cert $cert2Export -FilePath E:\CertOps\phortiknet-ps-aa.pfx -Password $myPass


#### Convert PFX to PEM using OpenSSL in WSL

wsl openssl pkcs12 -in /mnt/e/certops/phortiknet-ps-aa.pfx -noenc -nocerts -out /mnt/e/certops/phortiknet-ps-aa.pem
edit E:\CertOps\phortiknet-ps-aa.pem

# encrypt the private key
wsl openssl pkcs12 -in /mnt/e/certops/phortiknet-ps-aa.pfx -nocerts -out /mnt/e/certops/phortiknet-ps-encrypted-aa.pem
# Output the certificate chain
wsl openssl pkcs12 -in /mnt/e/certops/phortiknet-ps-aa.pfx -noenc -out /mnt/e/certops/phortiknet-ps-aa.cachain.pem
# inspect the certificate chain
wsl openssl x509 -in /mnt/e/certops/phortiknet-ps-aa.cachain.pem -noout -text
# retrieve just the public certificate
wsl openssl rsa -in /mnt/e/certops/phortiknet-ps-aa.pem -pubout -out /mnt/e/certops/phortiknet-ps-aa.cer


#### Security

$pth="E:\CertOps"
$secGrp="DARIENS\PrivateKeyAdmins:"
# remove existing permissions and inheritance
icacls $pth /inheritance:r
icacls $pth /grant:r "$secGrp(OI)(CI)F" "SYSTEM:(OI)(CI)F"

# BASH (LINUX/WSL) permissions
sudo chown root:root /certops
sudo chmod 600 /certops