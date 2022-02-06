# Interaction

A way to interact with all the entities on FiveM. Performance cost is really low (0.0ms idle - 0.06ms running). The script allow a bunch of options that will improve the game experience of players. Its an standalone resource.

## Features
- Generic options for all vehicles and ped.
- Really optimized.
- Ability to check whatever you want on each option.
- Support for vehicle bones.
- UI list updated at every moment.

## About
The ui has been built with [React](https://es.reactjs.org/) and packaged with [Vite](https://vitejs.dev/). The library used for icons is [React-icons](https://react-icons.github.io/react-icons) (Material Design). The client, shared and server files are served with [Lua](https://www.lua.org/) because its the standard on FiveM.

## Installation

If you download the [release version](https://github.com/franfdezmorales/interact/releases/tag/v1.0.0) you just need to drop the files on your resources folder and make sure you ensure the resource.

```bash
ensure interact
```

If you want to modify the ui of the script, you need to create a production build, just navigate to ui folder and run the following command after your changes: 

```bash
npm run build
```

## Usage

Its really easy to add new targets to interact: 

```lua
local newTargets = {
 -1403128555, 
 -6734242, 
}

addNewTarget(newTargets, {
    options = { -- You can add as many as you want
        {
            label = 'Option 1', -- The name will show on the ui list
            icon = 'MdLanguage', -- The icon will show on the ui list (https://react-icons.github.io/react-icons/icons?name=md)
            event = 'script:dowhatever', -- The client event that will be triggered when the user select the option
            bone = 'wheel_rr' -- (Optional) Only works with vehicles. Render the option if you are pointing the bone.
        }, 
        {
            label = 'Option 2', 
            icon = 'MdLanguage', 
            event = 'script:dowhatever', 
        }, 
    }, 
    distance = 5.0, -- The max distance will show the options when pointing
    enable = function(entity) -- Render the options if the function return true, really useful to check whatever you want.
        return true
    end 
})
```

If you have the debug enabled, on every entity that could be targeted you will see a option to save target, this will generate the above code on targets_interact.txt, you could find the txt file on your server-data folder.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)
