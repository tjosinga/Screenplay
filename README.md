Screenplay
==========

The purpose of this simple Ruby application is to set up scenario's which can be used for testing RESTful API's.

A developer may define scenarios which will be played sequentially. A scenario consists of a chain of actions.
Each action gets an input object, plays its role and returns an output object. These objects have the form of a hash or an array, or nil.
As soon as something fails, it raises an exception and aborts the application. Therefor valid testing should play all scenarios without fails.

## Features
- Send requests to an API, either expecting correct data or errors.
- Test the incoming data
- Cache (parts of) incoming for later use, i.e. with another API request.
- More to come...
Not all features are documented on this page yet.

## Terminology
- Screenplay: The application which plays scenarios
- Scenarios: A Yaml file containing all actions.
- Actions: An action is a single thing an actor does.
- Actor: The actor gets input data, plays its part and return an output data.


## Examples
As an example, Screenplay can play the following scenario file (i.e. ./scenarios/simple.yml)

```yaml
# Lets start with some data
- data:
    name: 'William Adama'
    callsign: 'husker'
    sons: ['Zak', 'Lee']

# Now do some minimal testing
- test:
    name:
      eq: 'William Adama'
    callsign:
      in: ['husker', 'starbuck']
```

When you want to use an API, first create the ./config.yml. The following example uses the free API of OpenWeatherMAP.
```yaml
api:
  url: http://api.openweathermap.org/data/2.5/
```

The following scenario file just retrieves data from the weahther API, without further testing.
./scenarios/api.yml
```yaml
- api:
    path: weather
    data:
      q: london,uk
```

For more examples, check the Examples folder.

## Installation
```bash
gem install screenplay
```

## Usage

### Command-line
Use the command-line tool screenplay to play your scenarios. The tool searches for the followings files:
- ./config.yml        # For configuration purposes.
- ./scenarios/*.yml   # The scenarios to play.
- ./actors/*.rb       # Custom actors. These will be loaded automatically.

The command-line tool has the following commands
```bash
screenplay play # This plays all available scenarios.
```
```bash
screenplay actors # Lists all available actors.
```
```bash
screenplay actors # Lists all available scenarios.
```

```bash
screenplay # Shows more information on the command-line tool.
```

### Ruby

```Ruby
require 'screenplay'

Screenplay.prepare # Automatically loads configuration, actors and scenarios
Screenplay.play # Plays all scenarios
```

## Actors
### Data
Outputs all data as written in the scenario.


```yaml
- data:
    callsign: 'husker'
    name: 'William Adama'
```
### Cache
Use the cache actor to set, get or merge data.

```yaml
- cache:
    set:
      var_name_how_its_stored: callsign
```
```yaml
- cache:
    get:
      callsign: var_name_how_its_stored
```

### API
The api actor sends request to an API and outputs the result.
```yaml
- api:
    path: users
    data:
      limit: 10
```
The following request posts user data in order to create a new users. In this case we expect a 403 error, because of not having the rights. If another code, like 200, will return, it raise an exception.
```yaml
- api:
    path: users
    method: post
    data:
      firstname: 'William'
      lastname: 'Adama'
    expect: 403
```

### Prompt
For command-line purposes the prompt actor asks the user for information:
```yaml
- prompt:
    username: Enter your username
    password: Enter your password
```

### Test
The test actor tests incoming data.
```yaml
- api:
    path: users
    data:
      limit: 10
```
```yaml
- test
    username:
      eq: 'husker'
```
You can use the following tests:
- lt
- lte
- eq
- gte
- gt
- in
- size
- regexp
