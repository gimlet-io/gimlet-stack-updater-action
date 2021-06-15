# Gimlet Stack Updater Action

## Testing locally

```
docker build -t myaction .
docker run -v $(pwd):/action -it --rm myaction "fixture/stack.yaml"
```

## Usage

```yaml
name: Update
on:
  push: {}

  schedule:
    - cron:  '* 13 * * *'

jobs:
  build:
    name: Demo
    runs-on: ubuntu-latest
    steps:

      - name: Checkout main
        uses: actions/checkout@v2
        with:
          ref: main

      - name: Updating stack
        uses: gimlet-io/gimlet-stack-updater-action@6b11b9ea3beeb8aa34c48964598287d11b717cc6
        with:
          config: 'fixture/stack.yaml'
          reviewer: "laszlocph"
        env:
          GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
```

See on [https://gimlet.io/gimlet-stack/upgrading-a-stack/](https://gimlet.io/gimlet-stack/upgrading-a-stack/)
