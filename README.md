# Zerops x Ruby
This is the most bare-bones example of a Ruby Sinatra app running on [Zerops](https://zerops.io) — as few gems as possible, just a simple endpoint with connect, read and write to a Zerops PostgreSQL database.

![ruby](https://github.com/zeropsio/recipe-shared-assets/blob/main/covers/svg/cover-ruby.svg)

<br />

## Deploy on Zerops
You can either click the deploy button to deploy directly on Zerops, or manually copy the import yaml to the import dialog in the Zerops app.

[![Deploy on Zerops](https://github.com/zeropsio/recipe-shared-assets/blob/main/deploy-button/green/deploy-button.svg)](https://app.zerops.io/recipe/ruby)

<br/>

## Recipe features
- **Ruby** with **Sinatra** on a load balanced **Zerops Ruby** service
- Zerops **PostgreSQL 16** service as database
- Healthcheck setup example via `/status` endpoint
- Utilization of Zerops' built-in **environment variables** system through dotenv
- Utilization of Zerops' built-in **log management** with various log levels

<br/>

## Production vs. development

Base of the recipe is ready for production, the difference comes down to:

- Use highly available version of the PostgreSQL database (change `mode` from `NON_HA` to `HA` in recipe YAML, `db` service section)
- Use at least two containers for the Ruby service to achieve high reliability and resilience (add `minContainers: 2` in recipe YAML, `api` service section)

Further things to think about when running more complex, highly available Ruby production apps on Zerops:

- Containers are volatile - use Zerops object storage to store your files
- Use Zerops Redis (KeyDB) for caching, storing sessions and pub/sub messaging
- Consider using Puma or Unicorn as production-ready application servers
- Use more advanced logging tools such as the Ruby port of structured logging libraries

<br/>
<br/>

Need help setting your project up? Join [Zerops Discord community](https://discord.com/invite/WDvCZ54).