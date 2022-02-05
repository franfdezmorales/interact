import { createContext, useContext, useState } from "react";
import { useNuiEvent } from "fivem-nui-react-lib";

const Context = createContext(undefined)

export const ContextProvider = ({children}) => {

    const [visible, setVisible] = useState(false)
    const [list, setList] = useState([])

    useNuiEvent('interact', 'toggleVisibility', setVisible)
    useNuiEvent('interact', 'updateInfo', (data) => {
        setList(data.list)
    })
    
    const value = {
        visible, 
        setVisible,
        list, 
        setList,
    }

    return <Context.Provider value={value}>{children}</Context.Provider>
}

export const useVisible = () => {
    const { visible, setVisible } = useContext(Context)
    return { visible, setVisible }
}

export const useList = () => {
    const { list, setList } = useContext(Context)
    return { list, setList }
}
