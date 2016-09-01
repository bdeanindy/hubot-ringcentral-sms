# hubot-ringcentral

This is a [Hubot](http://hubot.github.com/) adapter to use with [RingCentral SMS](https://www.ringcentral.com).

## Getting Started

#### Creating a new bot

- `npm install -g hubot coffee-script yo generator-hubot`
- `mkdir -p /path/to/hubot`
- `cd /path/to/hubot`
- `yo hubot` and enter 'ringcentral' (no quotes) when [prompted for the adapter, or set everything with the option flags](https://hubot.github.com/docs/)
- Initialize git and make your initial commit
- Check out the [hubot docs](https://github.com/github/hubot/tree/master/docs) for further guidance on how to build your bot

#### Testing your bot locally

- `HUBOT_RINGCENTRAL_SERVER=${ServerUrl} HUBOT_RINGCENTRAL_APIKEY=${AppKey} HUBOT_RINGCENTRAL_APISECRET=${AppSecret} HUBOT_RINGCENTRAL_USERNAME=${UserName} HUBOT_RINGCENTRAL_EXTENSION=${Extension} HUBOT_RINGCENTRAL_PASSWORD=${Password} ./bin/hubot --adapter ringcentral`
