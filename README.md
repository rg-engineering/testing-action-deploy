# iobroker-testing-action-deploy

Shared Github Actions for ioBroker testing workflows: Deploy step

## Inputs

| Input           | Description                                                        | Required? |      Default      |
| --------------- | ------------------------------------------------------------------ | --------- | :---------------: |
| `node-version`  | Node.js version to use in tests. Should be LTS.                    | ✔         |         -         |
| `build`         | Set to `'true'` when the adapter needs a build step before testing | ❌        |     `'false'`     |
| `build-command` | Overwrite the default build command                                | ❌        | `'npm run build'` |
| `npm-token`     | The token to use to publish to npm                                 | ✔         |         -         |
| `github-token`  | The token to use to create a GitHub release                        | ✔         |         -         |

## Usage

```yml
# ... rest of your workflow ...

jobs:
  deploy:
    needs: [check-and-lint, adapter-tests]

    # Trigger this step only when a commit on any branch is tagged with a version number
    if: |
      contains(github.event.head_commit.message, '[skip ci]') == false &&
      github.event_name == 'push' &&
      startsWith(github.ref, 'refs/tags/v')

    runs-on: ubuntu-latest

    steps:
      - uses: AlCalzone/iobroker-testing-action-deploy@v1
        with:
          node-version: '14.x' # This should be LTS
          # build: 'true' # optional
          npm-token: ${{ secrets.NPM_TOKEN }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
```
