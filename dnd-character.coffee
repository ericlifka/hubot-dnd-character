# Description:
#   You've got to start a new character and you're out of ideas.  Let me help.
# Notes:
#   Put the help here

helpText = '```
Create a randomized character idea:     who is my character\n
Add or remove character adjective:      (add|remove) adjective "<adjective>"\n
Add or remove character race:           (add|remove) race "<race>"\n
Add or remove character class:          (add|remove) class "<class>"\n
Add or remove character location:       (add|remove) location "<location>"\n
Add or remove character backstory:      (add|remove) backstory "<backstory>"\n
List item types:                        list <type>\n
```'

module.exports = (robot) ->
    defaults =
        dndAdjectives: "tough"
        dndRaces: "elf"
        dndClasses: "ranger"
        dndLocations: "the woodland kingdoms"
        dndBackstories: "doesn't take shit from anyone"

    getDb = (dbName) ->
        robot.brain.get(dbName) or [ defaults[dbname] ]

    randItem = (list) ->
        list[Math.floor(Math.random() * list.length)]

    robot.respond /character help/i, (msg) ->
        msg.send helpText

    robot.respond /(roll me a|create me a|who is my) character/i, (msg) ->
        adj = randItem getDb 'dndAdjectives'
        race = randItem getDb 'dndRaces'
        dclass = randItem getDb 'dndClasses'
        location = randItem getDb 'dndLocations'
        backstory = randItem getDb 'dndBackstories'

        msg.send "#{adj} #{race} #{dclass} from #{location} who #{backstory}."

    robot.respond /add (adjective|race|class|location|backstory) "([^\"]+)"/i, (msg) ->
        adjectives = robot.brain.get('dndAdjectives') or ['tough']
        races = robot.brain.get('dndRaces') or ['elf']
        classes = robot.brain.get('dndClasses') or ['ranger']
        locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
        backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
        newtype = msg.match[1]
        newcontent = msg.match[2]
        if newtype is 'adjective' and newcontent not in adjectives
            adjectives.push(newcontent)
            robot.brain.set 'dndAdjectives', adjectives
        if newtype is 'race' and newcontent not in races
            races.push(newcontent)
            robot.brain.set 'dndRaces', races
        if newtype is 'class' and newcontent not in classes
            classes.push(newcontent)
            robot.brain.set 'dndClasses', classes
        if newtype is 'location' and newcontent not in locations
            locations.push(newcontent)
            robot.brain.set 'dndLocations', locations
        if newtype is 'backstory' and newcontent not in backstories
            backstories.push(newcontent)
            robot.brain.set 'dndBackstories', backstories
        robot.brain.save
        msg.reply "Added new #{newtype}: #{newcontent}"

    robot.respond /remove (adjective|race|class|location|backstory) "([^\"]+)"/i, (msg) ->
        adjectives = robot.brain.get('dndAdjectives') or ['tough']
        races = robot.brain.get('dndRaces') or ['elf']
        classes = robot.brain.get('dndClasses') or ['ranger']
        locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
        backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
        newtype = msg.match[1]
        newcontent = msg.match[2]
        if newtype is 'adjective'
            itemIndex = adjectives.indexOf(newcontent)
            adjectives.splice(itemIndex, 1)
            robot.brain.set 'dndAdjectives', adjectives
        if newtype is 'race'
            itemIndex = races.indexOf(newcontent)
            races.splice(itemIndex, 1)
            robot.brain.set 'dndRaces', races
        if newtype is 'class'
            itemIndex = classes.indexOf(newcontent)
            classes.splice(itemIndex, 1)
            robot.brain.set 'dndClasses', classes
        if newtype is 'location'
            itemIndex = locations.indexOf(newcontent)
            locations.splice(itemIndex, 1)
            robot.brain.set 'dndLocations', locations
        if newtype is 'backstory'
            itemIndex = backstories.indexOf(newcontent)
            backstories.splice(itemIndex, 1)
            robot.brain.set 'dndBackstories', backstories
        robot.brain.save
        msg.reply "Removed #{newtype}: #{newcontent}"

    robot.respond /list (adjective|race|class|location|backstory)/i, (msg) ->
        adjectives = robot.brain.get('dndAdjectives') or ['tough']
        races = robot.brain.get('dndRaces') or ['elf']
        classes = robot.brain.get('dndClasses') or ['ranger']
        locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
        backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
        newtype = msg.match[1]
        if newtype is 'adjective'
            dndResponse = "Adjectives:\n```\"" + adjectives.join('"\n"') + "\"```"
            msg.send dndResponse
        if newtype is 'race'
            dndResponse = "Races:\n```\"" + races.join('"\n"') + "\"```"
            msg.send dndResponse
        if newtype is 'class'
            dndResponse = "Classes:\n```\"" + classes.join('"\n"') + "\"```"
            msg.send dndResponse
        if newtype is 'location'
            dndResponse = "Locations:\n```\"" + locations.join('"\n"') + "\"```"
            msg.send dndResponse
        if newtype is 'backstory'
            dndResponse = "Backstories:\n```\"" + backstories.join('"\n"') + "\"```"
            msg.send dndResponse