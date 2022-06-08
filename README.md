# Oiko – API server for Voikko

The repo contains a minimal REST API server for [Voikko](https://voikko.puimula.org/), a library for analysing and fixing Finnish text (spelling, grammar, hyphenation).

This webserver provides minimal external API for interacting with Voikko. The server is used as part of [TIM](https://github.com/TIM-JYU/TIM) learning content management system.

## Basic usage

The webserver is intended for use primarily via the [timimages/oiko](https://hub.docker.com/r/timimages/oiko) container.

Minimal example (starts the server and exposes it on `localhost:5000`):

```bash
docker run --rm -p 5000:5000 timimages/oiko:latest
```

## Available REST API

All API has prefix `/api/v1`.

#### Proofread a list of words `/proofread`

```
POST /api/v1/proofread
```

**Input type**: `Array<string>` encoded as JSON

**Return type**: `{ spelling: Record<string, [bool, Array<string>]>, tokenlists: Array<Array<[string, TokenType]>> }`


Proofreads a list of Finnish phrases and returns possible spellchecking suggestions if there are any.

Returns information about the spelling of each phrase and the tokenisation of them.

Example:

```bash
@ curl -H 'Content-Type: application/json' -d '["astee"]' -X POST http://localhost:5000/api/v1/proofread
{"spelling":{"astee":[false,["aste","asteet","asete","aseet","asteen"]]},"tokenlists":[[["astee",1]]]}
```


## License and credits

This project and Voikko are licensed under GPLv3.

The initial version of the API server was developed as part of the [Oiko project](https://tim.jyu.fi/view/kurssit/tie/proj/2019/oiko/projektin-esittely).