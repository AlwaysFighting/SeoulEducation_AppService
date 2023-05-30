const Wishlist = (sequelize, DataTypes) => {
  const Wishlist = sequelize.define(
    "Wishlist",
    {
      wishDate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Wishlist",
      timestamps: false,
    }
  );

  Wishlist.associate = (models) => {
    models.Wishlist.belongsTo(models.User, {
      foreignKey: "userId",
      sourceKey: "id",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
    models.Wishlist.belongsTo(models.Course, {
      foreignKey: "courseId",
      sourceKey: "id",
      onDelete: "cascade",
      onUpdate: "cascade",
    });
  };

  return Wishlist;
};

export default Wishlist;
