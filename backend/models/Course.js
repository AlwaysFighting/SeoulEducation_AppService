const Course = (sequelize, DataTypes) => {
  const Course = sequelize.define(
    "Course",
    {
      courseCode: {
        type: DataTypes.STRING(50),
        allowNull: false,
      },
      type: {
        type: DataTypes.STRING(10),
        allowNull: false,
        comment: "off / on",
      },
      title: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
      url: {
        type: DataTypes.STRING(2500),
        allowNull: true,
      },
      applyStartDate: {
        type: DataTypes.STRING(50),
        allowNull: true,
      },
      applyEndDate: {
        type: DataTypes.STRING(50),
        allowNull: true,
      },
      startDate: {
        type: DataTypes.STRING(50),
        allowNull: true,
        comment: "yyyy-mm-dd / always",
      },
      endDate: {
        type: DataTypes.STRING(50),
        allowNull: true,
        comment: "yyyy-mm-dd / always",
      },
      category: {
        type: DataTypes.STRING(50),
        allowNull: true,
      },
      deptName: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
      deptGu: {
        type: DataTypes.STRING(100),
        allowNull: true,
      },
      deptLat: {
        type: DataTypes.DECIMAL(16, 14),
        allowNull: true,
      },
      deptLng: {
        type: DataTypes.DECIMAL(17, 14),
        allowNull: true,
      },
      insertDate: {
        type: DataTypes.STRING(100),
        allowNull: false,
      },
      likeCount: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      imagePath: {
        type: DataTypes.STRING(2500),
        allowNull: true,
        defaultValue: null,
        comment: "online only",
      },
      isAvailable: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        comment: "online only",
      },
      isFree: {
        type: DataTypes.BOOLEAN,
        allowNull: true,
        comment: "online only",
      },
      capacity: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: 0,
        comment: "offline only",
      },
    },
    {
      charset: "utf8",
      collate: "utf8_general_ci",
      tableName: "Course",
      timestamps: false,
    }
  );

  Course.associate = (models) => {
    models.Course.belongsTo(models.Dept, {
      foreignKey: {
        name: "deptId",
        allowNull: true,
      },
    });
    models.Course.hasMany(models.Wishlist, {
      foreignKey: "courseId",
    });
    models.Course.hasMany(models.Notification, {
      foreignKey: "courseId",
    });
  };

  return Course;
};

export default Course;
