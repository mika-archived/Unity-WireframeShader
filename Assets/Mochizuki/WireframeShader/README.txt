# Wireframe Shader for Unity and VRChat

すべてのものをワイヤーフレーム (立体の辺のみを描写する) 化するシェーダーです。  
3種類のシェーダーを同梱しています。


## Mochizuki/Wireframe/Opaque

通常のワイヤーフレームシェーダーです。
特に理由が無ければこれを使うのを推奨します。
デモ用のシーンの中央のキューブでは、これを使用しています。


## Mochizuki/Wireframe/Transparent

透過処理に対応したワイヤーフレームシェーダーです。
Alpha 値が追加で設定可能になっています。


## Mochizuki/Wireframe/Particle Transparent

Particle System から召喚したメッシュでも綺麗に描画されるワイヤーフレームシェーダーです。
詳細はシェーダーコード内コメントにあるのですが、 Particle System が召喚するメッシュは座標が崩壊しているようなので、  
Particle System からこのシェーダーを使用したい場合は、これを設定してください。
設定類は Transparent と同じものが適用されます。


# 注意事項

不具合などがあるかもしれません。あらかじめご了承ください。
また、 VRChat や Unity の今後のアップデートにより、不具合などが発生する可能性があります。

なお、以下の環境において作成および動作確認を行っています。

・VRChat 2020.4.4p1
・Unity 2018.4.20f1
・Unity 2019.4.11f1

また、このシェーダーは Geometry Shader Stage を使用しているため、以下の条件を満たす場合のみ動作します。

・DirectX 11+ (Shader Model 4.0)
・OpenGL 3.2+
・OpenGL ES 3.2+
・Vulkan
・PS4 / XB1


# 使用方法について

以下のページにて解説しています。
また、変更履歴なども記載しています。

https://docs.mochizuki.moe/WireframeShader/


# 利用規約

本アセットについては、 利用規約 Version 1.0.0 (2020/12/30 版) が適用されます。
https://docs.mochizuki.moe/WireframeShader/Terms


# 連絡先

不具合や要望、技術的な解説などが必要であれば、下記連絡先までお願いします。  
ただし、突然 DM が来ると何かやらかしたのかと思うので、柔らかい言葉で話しかけて頂けると助かります。

- Twitter https://r.mochizuki.moe/BoothSupport (メンションもしくは DM)
- Twitter @6jz
- VRChat  natsuneko_vrc


## あとがき

MIYAVI Virtual Live Stage の周りをふよふよ浮いているキューブを作りたかったのですが、  
どうやらあれはそういうメッシュだったようです。泣きました。

https://twitter.com/6jz/status/1343926225467711488