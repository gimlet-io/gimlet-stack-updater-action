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
        uses: gimlet-io/gimlet-stack-updater-action@8a7eca359a41ef1349e3855d987014afd28d5681
        with:
          config: 'fixture/stack.yaml'
          reviewer: "laszlocph"
        env:
          GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
```

See on [https://gimlet.io/gimlet-stack/upgrading-a-stack/](https://gimlet.io/gimlet-stack/upgrading-a-stack/)
