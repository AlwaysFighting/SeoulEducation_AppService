import models from "../models/index.js";

const Comment = models.Comment;
const ReplyToComment = models.ReplyToComment;

const commentCount = async (postId) => {
  let count = 0;
  const comments = await Comment.findAll({
    where: {
      postId: postId,
    },
  }).then((res) => {
    return res;
  });

  for (const item of comments) {
    const replyCount = await ReplyToComment.count({
      where: {
        commentId: item["id"],
      },
    });

    count += replyCount;
  }

  count += comments.length;

  return count;
};

export default commentCount;
