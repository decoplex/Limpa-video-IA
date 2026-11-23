# premiere-c2pa-fix

Ferramenta de arrastar e soltar pra destravar exportações do **Premiere Pro** e do **Media Encoder** que ficam paradas em **"Validating ingredients" 100%**.

## O problema

Vídeos e imagens gerados por IA (Google Veo, Adobe Firefly e outros) já vêm com **Content Credentials** (metadados C2PA) gravados no arquivo: um "carimbo" que registra que o conteúdo foi feito com IA.

Quando esse material entra no projeto, direto ou dentro de um vídeo exportado do After Effects, o Premiere tenta validar esse carimbo na exportação e **trava** na tela:

```
Encoding ...
Validating ingredients (1 of 1)   100%
```

O que **não** resolve:

- reinstalar o driver da placa de vídeo;
- reinstalar o Media Encoder;
- trocar o renderizador (a Adobe bloqueou essa opção nas versões recentes);
- desmarcar "Apply Content Credentials" na exportação (o carimbo já está dentro do arquivo de origem).

## A solução

Tirar os metadados do arquivo **antes** de usar no projeto. A ferramenta "reembala" o vídeo sem os metadados, **sem recomprimir**: mesma qualidade, mesmo codec, e leva poucos segundos.

## Instalação

1. Instale o [FFmpeg](https://ffmpeg.org) uma única vez. Abra o **Terminal** do Windows e rode:

   ```
   winget install ffmpeg
   ```

   Depois feche e abra o Terminal de novo.

2. Baixe o arquivo `limpar-c2pa.bat` deste repositório e salve onde for prático (por exemplo, na Área de Trabalho).

## Como usar

1. Selecione um ou mais vídeos.
2. **Arraste em cima do `limpar-c2pa.bat`**.
3. Para cada vídeo, aparece uma cópia com `_limpo` no nome, na mesma pasta:

   ```
   cena1.mp4  →  cena1_limpo.mp4
   ```

O original não é alterado.

### Projeto já montado no Premiere?

1. Limpe o vídeo com a ferramenta.
2. No painel de projeto, clique com o botão direito no clipe → **Substituir mídia** (Replace Footage) → escolha a versão `_limpo`.
3. Exporte normalmente. Legendas, trilhas e cortes continuam no lugar.

### Dica de fluxo

Baixou um clipe de IA? Limpe **antes** de importar no After ou no Premiere. Assim nada da cadeia recebe o carimbo.

## O que a ferramenta faz e o que não faz

| | |
|---|---|
| Remove os metadados C2PA / Content Credentials | ✅ |
| Mantém vídeo e áudio sem recompressão | ✅ |
| Funciona com `.mp4` e `.mov` | ✅ |
| Remove o SynthID (marca d'água invisível do Google nos pixels) | ❌ Não remove. Ele não trava a exportação. |

Comando usado por baixo, se você preferir rodar na mão:

```
ffmpeg -i entrada.mp4 -map 0:v? -map 0:a? -c copy -map_metadata -1 -movflags +faststart saida_limpo.mp4
```

## Aviso importante

Esta ferramenta existe pra resolver um **bug de exportação**, não pra esconder o uso de IA. Se o seu vídeo usa IA de forma realista, sinalize isso ao publicar: YouTube, Instagram e outras plataformas têm essa opção, e alguns clientes e anúncios exigem. Use com responsabilidade.

## Licença

[MIT](LICENSE). Pode usar, modificar e compartilhar.
