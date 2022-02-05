import React from 'react'
import ReactDOM from 'react-dom'
import './index.css'
import App from './App'
import { ContextProvider } from './context/Provider'
import { NuiProvider } from 'fivem-nui-react-lib'

ReactDOM.render(
  <React.StrictMode>
    <NuiProvider resource='interact'>
      <ContextProvider>
        <App />
      </ContextProvider>
    </NuiProvider>
  </React.StrictMode>,
  document.getElementById('root')
)
