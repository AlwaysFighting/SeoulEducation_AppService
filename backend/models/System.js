const System = (sequelize, DataTypes) => {
  const System = sequelize.define(
    "System",
    {
      logDate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: sequelize.literal("CURRENT_TIMESTAMP"),
      },
      category: {
        type: DataTypes.STRING(50),
        allowNull: false,
        comment: "on / off / dept",
      },
      renewalDate: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      total_count: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      new_count: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "System",
      timestamps: false,
    }
  );
  return System;
};

export default System;
