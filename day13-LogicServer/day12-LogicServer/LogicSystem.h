#pragma once
#include "Singleton.h"
#include <queue>
class LogicSystem:public Singleton<LogicSystem>
{
	friend class Singleton<LogicSystem>;
public:
	~LogicSystem();
private:
	LogicSystem();

};

