# RunBook - Packer Baking TAMS Mock API AMI

Assumes:

* Packer installed
* Git installed
* AWS cli installed and configured with API credentials

---

Git Clone

`git clone git@github.com:SimplifyMyCloud/Packer-Recipe-Mock-TAMS-API.git`

`cd Packer-Recipe-Mock-TAMS-API`

Packer Validate

`packer validate .`

Packer Build

`packer build .`