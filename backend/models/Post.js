const Post = (sequelize, DataTypes) => {
  const Post = sequelize.define(
    "Post",
    {
      title: {
        type: DataTypes.STRING(200),
        allowNull: false,
      },
      content: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
      publishDate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
      },
      viewCount: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      isEdited: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Post",
      timestamps: false,
    }
  );

  Post.associate = (models) => {
    models.Post.belongsTo(models.User, {
      foreignKey: "userId",
      sourceKey: "id",
      onDelete: "set null",
      onUpdate: "cascade",
    });
    models.Post.hasMany(models.Comment, {
      foreignKey: "postId",
      onUpdate: "cascade",
    });
    models.Post.hasMany(models.Notification, {
      foreignKey: "postId",
    });
  };

  return Post;
};

export default Post;
