variable "LOCAL" {
  default=false
}
variable "ARM64" {
  default=true
}
variable "AMD64" {
  default=true
}
variable "TAG" {
  default=""
}

group "default" {
  targets = [
    "devcontainer-truffle",
  ]
}
# [ NOTE ] create a builder for this file
# docker buildx create --use --name "devcontainer-truffle" --driver docker-container

# LOCAL=true docker buildx bake --builder devcontainer-truffle
# LOCAL=true ARM64=false AMD64=true docker buildx bake --builder devcontainer-truffle
# LOCAL=true ARM64=true AMD64=false docker buildx bake --builder devcontainer-truffle

target "devcontainer-truffle" {
    context="./"
    dockerfile = "Dockerfile"
    args = {
      IMAGE = "crizstian/devcontainer-core-node:latest"
    }
    tags = [
        "crizstian/devcontainer-truffle:latest",
        notequal("",TAG) ? "crizstian/devcontainer-truffle:${TAG}": "",
    ]
    platforms = [
        equal(AMD64,true) ?"linux/amd64":"",
        equal(ARM64,true) ?"linux/arm64":"",
    ]
    cache-from = [equal(LOCAL,true) ? "type=registry,ref=crizstian/devcontainer-truffle:cache":""]
    cache-to   = [equal(LOCAL,true) ? "type=registry,mode=max,ref=crizstian/devcontainer-truffle:cache" : ""]
    output     = [equal(LOCAL,true) ? "type=docker" : "type=registry"]
}