import styles from './List.module.css'
import { ItemList } from '../ItemList'
import { useList } from '../../context/Provider'
import * as Icons from 'react-icons/md'

export const List = () => {

    const { list } = useList()

    return (
        <div className={styles.listContainer}>
            <ul className={styles.list}>
                {list.map(item => (
                    <ItemList key={item.event} icon={Icons[item.icon] ?? Icons['MdCircle']} label={item.label} event={item.event} entity={item.entity}/>
                ))}
            </ul>
        </div>
    )
}