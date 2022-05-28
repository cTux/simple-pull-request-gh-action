# Simple Pull Request GitHub Action
A GitHub action that automates creating pull requests. Just specify command to execute and this action will create a pull request if changes were detected.

### This action helps with:
* Auto-updating dependencies ([project](./packages/npm-dependencies), [action](./.github/workflows/npm-dependencies.yml))
* Auto-fixing issues after dependencies audit ([project](./packages/npm-dependencies), [action](./.github/workflows/npm-dependencies-audit.yml))
* Auto-generating types
* Auto-fetching new localization
* Auto-updating public API data saved locally

## How to use?
```yaml
name: Automatic PR

on:
  schedule:
    - cron: '0/60 * * * *'

jobs:
  update-dependencies:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout the head commit of the branch
        uses: actions/checkout@v2
        with:
          persist-credentials: false

      - name: Run command
        uses: ctux/simple-pull-request-gh-action@1.0.2-rc
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          command: "'echo 3 >> file.txt'"
          commit_message: "'add(app): new file'"
```

## Inputs

| Name             | Description                                    | Required | Default             |
|------------------|------------------------------------------------|----------|---------------------|
| command          | Command to execute.                            | Yes      | N/A                 |
| token            | GITHUB_TOKEN or a Personal Access Token (PAT). | Yes      | N/A                 |
| branch_main_name | Base branch name.                              | No       | main                |
| branch_pr_name   | Changes branch name.                           | No       | simple-pr-changes   |
| commit_message   | Commit message for a pull request.             | No       | chore(app): changes |
| path             | Working directory path.                        | No       | ''                  |

## Notes:
* The committer name is set to the GitHub Actions bot user. GitHub <noreply@github.com>

## License
This tool is distributed under the terms of the MIT license. See [LICENSE](./LICENSE) for details.
