mineros = {};
bgNum = 6;
pNum = 5;
pSep = 600;
pSkip = 300;
bgTarget = 0;
specialBg = 0;

iniScroll = scrollSpeed;

function onCreate()
	for i = 0, bgNum - 1, 1
	do
		local name = 'bg-'..i;
		makeLuaSprite(name, 'bg/'..name, -300, -200);
		setScrollFactor(name, 0, 0);
		if (i > 0) then
			setProperty(name..".alpha", 0);
		end

		if (i == 4) then
			setScrollFactor(name, 0.4, 0.4);
			setProperty(name..".x", -800);
		elseif (i == 5) then
			setScrollFactor(name, 0.5, 0.5);
			setProperty(name..".x", -800);
			setProperty(name..".y", -300);
		end
		addLuaSprite(name, false);
	end

	for i = 0, 3, 1
	do
		local mName = '33-'..i..'-';
		local dir = 1;

		if (i % 2 == 1) then
			dir = -1;
		end

		makeLuaSprite(mName..'0', 'bg/mineros', 0, -100 + i * 300);
		setScrollFactor(mName..'0', 0.4, 0.4);
		makeLuaSprite(mName..'1', 'bg/mineros', 2800 * dir, -100 + i * 300);
		setScrollFactor(mName..'1', 0.4, 0.4);

		setProperty(mName.."0.alpha", 0);
		setProperty(mName.."1.alpha", 0);
		addLuaSprite(mName..'0', false);
		addLuaSprite(mName..'1', false);
	end

	for i = 0, pNum - 1, 1
	do
		local bName = 'bounce-'..i;
		makeAnimatedLuaSprite(bName, 'bg/bg_bounce', -pSkip + i * pSep, 300);
		addAnimationByPrefix(bName, 'dance', 'dance', 24, false);
		setLuaSpriteScrollFactor(bName, 0.6, 0.6);
		addLuaSprite(bName, false);
		objectPlayAnimation(bName, 'dance', true);
		setProperty(bName..".alpha", 0);
		setProperty(bName..".scale.x", 2);
		setProperty(bName..".scale.y", 2);
		setProperty(bName..".offset.x", getProperty(bName..'.frameWidth') / 2);
		setProperty(bName..".offset.y", getProperty(bName..'.frameHeight') / 2);
	end

	makeAnimatedLuaSprite('sLines', 'bg/spdLines', 1280 / 2, 720 / 2);
	addAnimationByPrefix('sLines', 'idle', 'spdLines', 30, true);
	updateHitbox('sLines');
	setProperty("sLines.offset.x", getProperty('sLines.width') / 2);
	setProperty("sLines.offset.y", getProperty('sLines.height') / 2);
	setLuaSpriteScrollFactor('sLines', 0, 0);
	setProperty("sLines.scale.x", 2.5);
	setProperty("sLines.scale.y", 2.5);
	setProperty("sLines.alpha", 0);
	--setProperty('sLines.camera', getProperty('camHUD'));
	addLuaSprite('sLines', true);
	objectPlayAnimation('sLines', 'idle', true);
end

function onBeatHit()
	if (curBeat % 2 == 0) then
		for i = 0, pNum - 1, 1
		do
			local bName = 'bounce-'..i;
			objectPlayAnimation(bName, 'dance', true);
		end
	end
end

time = 0.0;
function onUpdate(elapsed)
	--defaultPlayerStrumX0 = defaultPlayerStrumX0 - 1;
	time = time + elapsed * 60;
	for i = 0, bgNum - 1, 1
	do
		local name = 'bg-'..i;
		local alName = name..".alpha";
		local prevA = getProperty(alName);
		local spd = elapsed * 2;

		if (i == bgTarget) then
			if (prevA < 1) then
				setProperty(alName, prevA + spd);
			end
		else
			if (prevA > 0) then
				setProperty(alName, prevA - spd);
			end
		end
	end

	for i = 0, pNum - 1, 1 do
		local bName = 'bounce-'..i;
		setProperty(bName..'.y', 300 + math.sin((time * 7 + i*70) / 180 * 3.1416) * 40);
		setProperty(bName..'.x', getProperty(bName..'.x') - elapsed * 300);
		if (getProperty(bName..'.x') < -pSkip - pSep) then
			setProperty(bName..'.x', getProperty(bName..'.x') + pSep * (pNum));
		end

		local alName = bName..".alpha";
		local prevA = getProperty(alName);
		local spd = elapsed * 2;

		if (specialBg == 3) then
			if (prevA < 1) then
				setProperty(alName, prevA + spd);
			end
		else
			if (prevA > 0) then
				setProperty(alName, prevA - spd);
			end
		end
	end

	local alName = "sLines.alpha";
	local prevA = getProperty(alName);
	local spd = elapsed * 2;

	if (specialBg == 2) then
		if (prevA < 1) then
			setProperty(alName, prevA + spd);
		end
	else
		if (prevA > 0) then
			setProperty(alName, prevA - spd);
		end
	end

	--que chucha estoy haciendo esta wea es mas confusa que la cresta 💀💀💀
	for i = 0, 3, 1
	do
		local mName = '33-'..i..'-';

		for j = 0, 1, 1 do
			local obj = mName..j;
			local getIt = obj..'.x';
			local dir = -1;

			if (i % 2 == 1) then
				dir = 1;
			end
			setProperty(getIt, getProperty(getIt) + dir * elapsed * 100);

			local w = getProperty(obj..'.width');
			if (getProperty(getIt) < - w) then
				setProperty(getIt, w);
			end

			if (getProperty(getIt) > w) then
				setProperty(getIt, -w);
			end

			local alName = obj..".alpha";
			local prevA = getProperty(alName);
			local spd = elapsed * 2;

			if (specialBg == 1) then
				if (prevA < 1) then
					setProperty(alName, prevA + spd);
				end
			else
				if (prevA > 0) then
					setProperty(alName, prevA - spd);
				end
			end
		end
	end
end

function onEvent(name, value1, value2)
	if name == 'bgChange' then
		bgTarget = tonumber(value1);

		if (value2 ~= '') then
			specialBg = tonumber(value2);
		end
	end
end