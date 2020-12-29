# Wireframe Shader for Unity and VRChat

Wireframe Shader for Unity and VRChat.  
This shader was inspired by the MIYAVI virtual live stage, and I later realized that it was probably just a simple Mesh.

<img src="https://user-images.githubusercontent.com/10832834/103256675-78496300-49d1-11eb-8d69-e4a7bd43b53a.PNG">

## Requirements

- Unity 2018.4.20f1 / 2019.4.11f1
- GPU and Graphics API that supporting Geometry Shader Stage

## Features

- Display Wireframe of Mesh
- Ignore Diagonal Lines
- Emission
- Shadow Caster

## Installation (Not Yet Provided)

1. Download UnityPackage from BOOTH (Recommended)
2. Install via NPM Scoped Registry

### Download UnityPackage

You can download latest version of UnityPackage from BOOTH (Not Yet Provided).  
Extract downloaded zip package and install UnityPackage into your project.

### Install via NPM

Please add the following section to the top of the package manifest file (`Packages/manifest.json`).  
If the package manifest file already has a `scopedRegistries` section, it will be added there.

```json
{
  "scopedRegistries": [
    {
      "name": "Mochizuki",
      "url": "https://registry.npmjs.com",
      "scopes": ["moe.mochizuki"]
    }
  ]
}
```

And the following line to the `dependencies` section:

```json
"moe.mochizuki.wireframe-shader": "VERSION"
```

## How to use (Documentation / Japanese)

https://docs.mochizuki.moe/WireframeShader/ (Not Yet Provided)

## License

MIT by [@6jz](https://twitter.com/6jz)
