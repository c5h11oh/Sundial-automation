# just add one key for everyone
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAo8xPrFFYR34cEcfSTFnKqITSjcW89HJtVpOJOBVfBy whwang8@wisc.edu" >> ~/.ssh/authorized_keys

echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACAKPMT6xRWEd+HBHH0kxZyqiE0o3FvPRybVaTiTgVXwcgAAAJg7xuGAO8bh
gAAAAAtzc2gtZWQyNTUxOQAAACAKPMT6xRWEd+HBHH0kxZyqiE0o3FvPRybVaTiTgVXwcg
AAAEA0rOLBNvfl4Rg3tAqAR6vOSJeyMHBiRG/IoP/n+/OSPwo8xPrFFYR34cEcfSTFnKqI
TSjcW89HJtVpOJOBVfByAAAAEHdod2FuZzhAd2lzYy5lZHUBAgMEBQ==
-----END OPENSSH PRIVATE KEY-----" > ~/.ssh/id_ed25519
chmod 400 ~/.ssh/id_ed25519 
