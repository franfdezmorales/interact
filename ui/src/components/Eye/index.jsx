import styles from './Eye.module.css'
import { MdRemoveRedEye } from 'react-icons/md'
import { useList } from '../../context/Provider'
import { useEffect } from 'react'

export const Eye = () => {

    const { list } = useList()

    const currentColor = list.length > 0 ? '#0F9' : '#DFDFDF'

    return (
        <MdRemoveRedEye size='3em' color={currentColor} className={styles.eye}/>
    )
}