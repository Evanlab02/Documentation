# Pull Request

| Webhook event payload                                                                                              | Activity types                                                                                                                                                                                                                                                                                                                                                                                                                                       | `GITHUB_SHA`                                 | `GITHUB_REF`                                          |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | ----------------------------------------------------- |
| [`pull_request`](https://docs.github.com/en/webhooks-and-events/webhooks/webhook-events-and-payloads#pull_request) | - `assigned`  <br>- `unassigned`  <br>- `labeled`  <br>- `unlabeled`  <br>- `opened`  <br>- `edited`  <br>- `closed`  <br>- `reopened`  <br>- `synchronize`  <br>- `converted_to_draft`  <br>- `locked`  <br>- `unlocked`  <br>- `enqueued`  <br>- `dequeued`  <br>- `milestoned`  <br>- `demilestoned`  <br>- `ready_for_review`  <br>- `review_requested`  <br>- `review_request_removed`  <br>- `auto_merge_enabled`  <br>- `auto_merge_disabled` | Last merge commit on the `GITHUB_REF` branch | PR merge branch `refs/pull/PULL_REQUEST_NUMBER/merge` |

For example, you can run a workflow when a pull request has been opened or reopened.

```yaml
on:
  pull_request:
    types: [opened, reopened]
```

You can use the event context to further control when jobs in your workflow will run. For example, this workflow will run when a review is requested on a pull request, but the `specific_review_requested` job will only run when a review by `octo-team` is requested.

```yaml
on:
  pull_request:
    types: [review_requested]
jobs:
  specific_review_requested:
    runs-on: ubuntu-latest
    if: ${{ github.event.requested_team.name == 'octo-team'}}
    steps:
      - run: echo 'A review from octo-team was requested'
```

## Running your `pull_request` workflow based on the head or base branch of a pull request

You can use the `branches` or `branches-ignore` filter to configure your workflow to only run on pull requests that target specific branches. For more information, see [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpull_requestpull_request_targetbranchesbranches-ignore).

For example, this workflow will run when someone opens a pull request that targets a branch whose name starts with `releases/`:

```yaml
on:
  pull_request:
    types:
      - opened
    branches:
      - 'releases/**'
```

If you use both the `branches` filter and the `paths` filter, the workflow will only run when both filters are satisfied. For example, the following workflow will only run when a pull request that includes a change to a JavaScript (`.js`) file is opened on a branch whose name starts with `releases/`:

```yaml
on:
  pull_request:
    types:
      - opened
    branches:
      - 'releases/**'
    paths:
      - '**.js'
```

To run a job based on the pull request's head branch name (as opposed to the pull request's base branch name), use the `github.head_ref` context in a conditional. For example, this workflow will run whenever a pull request is opened, but the `run_if` job will only execute if the head of the pull request is a branch whose name starts with `releases/`:

```yaml
on:
  pull_request:
    types:
      - opened
jobs:
  run_if:
    if: startsWith(github.head_ref, 'releases/')
    runs-on: ubuntu-latest
    steps:
      - run: echo "The head of this PR starts with 'releases/'"
```

## Running your `pull_request` workflow based on files changed in a pull request

You can also configure your workflow to run when a pull request changes specific files. For more information, see [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore).

For example, this workflow will run when a pull request includes a change to a JavaScript file (`.js`):

```yaml
on:
  pull_request:
    paths:
      - '**.js'
```

If you use both the `branches` filter and the `paths` filter, the workflow will only run when both filters are satisfied. For example, the following workflow will only run when a pull request that includes a change to a JavaScript (`.js`) file is opened on a branch whose name starts with `releases/`:

```yaml
on:
  pull_request:
    types:
      - opened
    branches:
      - 'releases/**'
    paths:
      - '**.js'
```

## Running your `pull_request` workflow when a pull request merges

When a pull request merges, the pull request is automatically closed. To run a workflow when a pull request merges, use the `pull_request` `closed` event type along with a conditional that checks the `merged` value of the event. For example, the following workflow will run whenever a pull request closes. The `if_merged` job will only run if the pull request was also merged.

```yaml
on:
  pull_request:
    types:
      - closed

jobs:
  if_merged:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
    - run: |
        echo The PR was merged
```