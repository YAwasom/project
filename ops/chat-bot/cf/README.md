# Deploying CloudFormation

The recommend approach is to use [simple-cfn](https://www.npmjs.com/package/simple-cfn).

Parameter configurations are stored under the [cf/parameters](./cf/parameters) directory.

```bash
simple-cfn deploy {stack-name} /path/template.yaml --file=parameters/path/type.{env}.yaml
```

## Order of deploy with StackName

- It is required to auth the slack plugin with admin privileges pre deploying this cf. 
- Go to ChatBot AWS Console UI and configure the workspace per account manually first.

- AWS Chat Bot
  - cmd-ops-slack-chat-bot
```bash
  simple-cfn deploy cmd-ops-slack-chat-bot templates/ops-chat-bot.yaml --file=parameters/ops-chat-bot.yaml
```