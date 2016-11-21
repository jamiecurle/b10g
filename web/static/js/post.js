let Post = {
    init(socket, element){
        // if no element return
        if (!element){
            console.log("No element: abort")
            return
        }

        // connect
        socket.connect();

        this.onReady(element.dataset.id, socket)
    },

    onReady(postId, socket){

        let postChannel = socket.channel("posts:" + postId)


        postChannel
            .on("change",  post => document.getElementById("post-body").innerHTML = post.body)

        postChannel.join().receive("error", reason => console.log("joined failed", reason))

    }
}


export default Post