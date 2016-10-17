# hubot-ringcentral-sms

This is a [Hubot](http://hubot.github.com/) adapter to use with [RingCentral SMS](https://www.ringcentral.com).

## Getting Started

#### Creating a new bot

- `npm install -g hubot coffee-script yo generator-hubot`
- `mkdir -p /path/to/hubot`
- `cd /path/to/hubot`
- `yo hubot` and enter 'ringcentral-sms' (no quotes) when [prompted for the adapter, or set everything with the option flags](https://hubot.github.com/docs/)
- Initialize git and make your initial commit
- Rename the environment template file `mv .env.tmpl .env` and fill in the values as expected
> HUBOT_HEROKU_KEEPALIVE_URL= URL of either ngrok (local) or your deployed hubot instance root
> RINGCENTRAL_ENV=sandbox||production
> RINGCENTRAL_APP_NAME={{NAME OF YOUR RINGCENTRAL APP}}
> RINGCENTRAL_APP_SERVER=https://platform[.devtest.]ringcentral.com
> RINGCENTRAL_APP_KEY={{YOUR RINGCENTRAL APP KEY}}
> RINGCENTRAL_APP_SECRET={{YOUR RINGCENTRAL APP SECRET}}
> RINGCENTRAL_USERNAME= {{YOUR RINGCENTRAL USERNAME}}
> RINGCENTRAL_PASSWORD={{YOUR RINGCENTRAL PASSWORD}}
> DELIVERY_MODE_TRANSPORT_TYPE=WebHook
> DELIVERY_MODE_ADDRESS= URL of either ngrok (local) or your deplyed hubot instance + /webhooks
> WEBHOOK_TOKEN={{UNIQUE TOKEN FOR YOUR WEBHOOKS}}
> HUBOT_SMS_FROM={{SHOULD MATCH YOUR RINGCENTRAL_USERNAME OR BE A VALID NUMBER USER HAS PERMISSION TO SEND SMS FROM}}
- Check out the [hubot docs](https://github.com/github/hubot/tree/master/docs) for further guidance on how to build your bot

#### Testing your bot locally

./bin/hubot --adapter ringcentral-sms`

## Changelog

Please see the [CHANGELOG](CHANGELOG) for more information.

## License

hubot-ringcentral-sms adapter is available under an MIT-style license. See [LICENSE](LICENSE) for details.
