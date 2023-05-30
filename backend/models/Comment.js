const Comment = (sequelize, DataTypes) => {
  const Comment = sequelize.define(
    "Comment",
    {
      content: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      publishDate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Comment",
      timestamps: false,
    }
  );

  Comment.associate = (models) => {
    models.Comment.hasMany(models.ReplyToComment, {
      foreignKey: "commentId",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
    models.Comment.belongsTo(models.User, {
      foreignKey: "userId",
      sourceKey: "id",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
    models.Comment.belongsTo(models.Post, {
      foreignKey: "postId",
      sourceKey: "id",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
    models.Comment.hasMany(models.Notification, {
      foreignKey: "commentId",
    });
  };

  return Comment;
};

export default Comment;
