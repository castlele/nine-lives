class_name Animator extends Object


static func fade(from: float, to: float, step: float, current: float) -> float:
	if from > to:
		if current <= to:
			return current

		return current - step

	if current >= to:
		return current

	return current + step
