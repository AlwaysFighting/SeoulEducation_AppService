const Notification = (sequelize, DataTypes) => {
  const Notification = sequelize.define(
    "Notification",
    {
      title: {
        type: DataTypes.STRING(60),
        allowNull: true,
      },
      content: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      category: {
        type: DataTypes.STRING(50),
        allowNull: true,
        comment: "new / last / comment / reply",
      },
      isChecked: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
      publishDate: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
      },
      courseId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: null,
        comment: "last only",
      },
      postId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: null,
        comment: "comment / reply only",
      },
      commentId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: null,
        comment: "comment / reply only",
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Notification",
      timestamps: false,
    }
  );

  Notification.associate = (models) => {
    models.Notification.belongsTo(models.User, {
      foreignKey: "userId",
      sourceKey: "id",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
    models.Notification.belongsTo(models.Course, {
      foreignKey: "courseId",
      sourceKey: "id",
      onDelete: "set null",
      onUpdate: "cascade",
    });
    models.Notification.belongsTo(models.Post, {
      foreignKey: "postId",
      sourceKey: "id",
      onDelete: "set null",
      onUpdate: "cascade",
    });
    models.Notification.belongsTo(models.Comment, {
      foreignKey: "commentId",
      sourceKey: "id",
      onDelete: "set null",
      onUpdate: "cascade",
    });
  };

  return Notification;
};

export default Notification;
