import { useEffect } from 'react'
import './App.css'
import { Eye } from './components/eye'
import { List } from './components/List'
import { useVisible } from './context/Provider'
import { Post } from './utils/post'

function App() {

  const { visible } = useVisible()

  const handleKeyDown = (e) => {
    switch(e.keyCode) {
      case 27: 
        Post('closeUI')
        break
      case 8: 
        Post('closeUI')
        break
    }
  }

  useEffect(() => {
    window.addEventListener('keydown', handleKeyDown)

    return () => {
      window.removeEventListener('keydown', handleKeyDown)
    }
}, [])
  
  return (
    <>
      {visible 
      ? 
        <div className='main-container'>
          <Eye />
          <List />
        </div> 
      : 
        null}
    </>
  )
}

export default App
