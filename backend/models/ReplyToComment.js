const ReplyToComment = (sequelize, DataTypes) => {
  const ReplyToComment = sequelize.define(
    "ReplyToComment",
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
      tableName: "ReplyToComment",
      timestamps: false,
    }
  );

  ReplyToComment.associate = (models) => {
    models.ReplyToComment.belongsTo(models.User, {
      foreignKey: "userId",
      sourceKey: "id",
      onDelete: "set null",
      onUpdate: "cascade",
    });
    models.ReplyToComment.belongsTo(models.Comment, {
      foreignKey: "commentId",
      sourceKey: "id",
      onUpdate: "cascade",
    });
  };

  return ReplyToComment;
};

export default ReplyToComment;
