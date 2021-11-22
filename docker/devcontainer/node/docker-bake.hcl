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
    "devcontainer-core-node",
  ]
}
# [ NOTE ] create a builder for this file
# docker buildx create --use --name "devcontainer-core-node" --driver docker-container

# LOCAL=true docker buildx bake --builder devcontainer-core-node
# LOCAL=true ARM64=false AMD64=true docker buildx bake --builder devcontainer-core-node
# LOCAL=true ARM64=true AMD64=false docker buildx bake --builder devcontainer-core-node

target "devcontainer-core-node" {
    context="."
    dockerfile = "Dockerfile"
    args = {
      IMAGE = "node:16"
    }
    tags = [
        "crizstian/devcontainer-core-node:latest",
        notequal("",TAG) ? "crizstian/devcontainer-core-node:${TAG}": "",
    ]
    platforms = [
        equal(AMD64,true) ?"linux/amd64":"",
        equal(ARM64,true) ?"linux/arm64":"",
    ]
    cache-from = [equal(LOCAL,true) ? "type=registry,ref=crizstian/devcontainer-core-node:cache":""]
    cache-to   = [equal(LOCAL,true) ? "type=registry,mode=max,ref=crizstian/devcontainer-core-node:cache" : ""]
    output     = [equal(LOCAL,true) ? "type=docker" : "type=registry"]
}