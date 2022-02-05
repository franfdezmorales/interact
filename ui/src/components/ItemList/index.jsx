import { createElement } from 'react'
import styles from './ItemList.module.css'
import { Post } from '../../utils/post'

export const ItemList = ({icon, label, event, entity}) => {

    const handleClick = () => {
        Post('targetSelected', {event: event, entity: entity})
    }

    return (
        <li className={styles.item} onClick={handleClick}>
            {createElement(icon, {style: {fontSize: '1.5em', color: '#0F9'}})}
            <span className={styles.label}>{label}</span>
        </li>
    )
}