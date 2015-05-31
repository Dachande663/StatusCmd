StatusCmd
==================

A tiny menu bar app for OS X powered by json.

StatusCmd is a weekend project to learn Swift. It reads a json file to generate
an OS X menu bar app. Use it to display a list of servers, launch common
commands or whatever else you can think of. It's basic and there's a feature
list a mile long, but it's out there for anyone else to use.

![Image of StatusCmd](https://raw.githubusercontent.com/Dachande663/StatusCmd/master/screenshot.jpg)

[Download latest](https://raw.githubusercontent.com/Dachande663/StatusCmd/master/releases/StatusCmd.app.zip)


Schema
------

When launched, StatusCmd looks for a file called .statuscmd in your home
directory, creating it if not found. This file should be a well-formed json
object defining the menu.

```json
{
  "menu": []
}
```

Each menu item supports the following properties:

```json
{
  "title": "Item title",
  "enabled": true,
  "separator": false,
  "command": "",
  "arguments": [],
  "menu": []
}
```

| Key       | Description                                   |
| --------- | ----------------------------------------------|
| title     | The menu item title                           |
| enabled   | If false, menu item is not clickable          |
| separator | If true, the item is a separator line         |
| command   | The full path to the command to run           |
| arguments | The array of arguments to pass to the command |
| menu      | An array of sub-menu items                    |


Example
-------

```json
{
  "menu": [
    {
      "title": "Good Morning, Dave",
      "enabled": false
    },
    {
      "separator": true
    },
    {
      "title": "Links",
      "menu": [
        {
          "title": "Hacker News",
          "command": "/usr/bin/open",
          "arguments": ["https://news.ycombinator.com/"]
        },
        {
          "title": "/r/programming",
          "command": "/usr/bin/open",
          "arguments": ["http://www.reddit.com/r/programming"]
        }
      ]
    },
    {
      "title": "Directories",
      "menu": [
        {
          "title": "www",
          "command": "/usr/bin/open",
          "arguments": ["/var/www"]
        }
      ]
    },
    {
      "title": "Servers",
      "menu": [
        {
          "title": "Local",
          "menu": [
            {
              "title": "Local Box",
              "command": "/usr/bin/open",
              "arguments": ["ssh://user@127.0.0.1:2202"]
            }
          ]
        },
        {
          "title": "Remote",
          "menu": [
            {
              "title": "Remote Box",
              "command": "/usr/bin/open",
              "arguments": ["ssh://user@123.123.123.123"]
            }
          ]
        }
      ]
    },
    {
      "separator": true
    },
    {
      "title": "Edit me in Sublime Text 2",
      "command": "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl",
      "arguments": ["~/.statuscmd"]
    }
  ]
}
```


Wishlist
--------

- [ ] Show json error on decoding
- [ ] Changeable bar icons
- [ ] Extra types of menu items (spark line, colours)
- [ ] Don't rebuild entire menu item every time
- [ ] Watch for changes, don't poll
- [ ] Support multiple source files
- [ ] Support multiple instances with different sources
- [ ] Load path for current user
- [ ] Better command and argument passing


Changelog
---------

* **[2015-05-09]** Initial hack
* **[2015-05-31]** First release
