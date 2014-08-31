Screenplay
==========

The purpose of this simple Ruby application is to set up scenario's which can be used for testing RESTful API's.

A developer may define scenarios which will be played sequentially. A scenario consists of a chain of actions.
Each action gets an input object, plays its role and returns an output object. These objects have the form of a hash or an array, or nil.

## Terminology
- Screenplay: The application which plays scenarios
- Scenarios: A Yaml file containing all actions. 
- Actions: An action is a single thing an actor does.
- Actor: The actor gets input data, plays its part and return an output data.

## Examples
As an example, Screenplay can play the following scenario file (i.e. ./scenarios/simple.yml)

```YAML
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


