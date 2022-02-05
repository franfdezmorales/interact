export const Post = async (url, data) => {
    const response = await fetch(`https://interact/${url}`, {
        method: 'POST', 
        body: JSON.stringify(data)
    })

    return response.json()
}