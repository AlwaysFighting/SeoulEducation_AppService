const Dept = (sequelize, DataTypes) => {
  const Dept = sequelize.define(
    "Dept",
    {
      name: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
      tel: {
        type: DataTypes.STRING(20),
        allowNull: true,
      },
      addr: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
      url: {
        type: DataTypes.STRING(2500),
        allowNull: true,
      },
      lat: {
        type: DataTypes.DECIMAL(16, 14),
        allowNull: true,
      },
      lng: {
        type: DataTypes.DECIMAL(17, 14),
        allowNull: true,
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Dept",
      timestamps: false,
    }
  );

  Dept.associate = (models) => {
    models.Dept.hasMany(models.Course, {
      foreignKey: { name: "deptId", allowNull: true },
    });
  };

  return Dept;
};

export default Dept;
