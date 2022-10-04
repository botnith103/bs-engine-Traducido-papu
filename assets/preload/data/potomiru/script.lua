toX = {};
toY = {};

eToX = {};
eToY = {};

defX = {};
defY = {};
eDefX = {};
eDefY = {};

mod = -1;
camMod = -1;
mirror = true;

--le robé el codigo al bbpanzu jijijija
local angleshit = 1;
local anglevar = 2;

function onCreate()
	for i = 0, 3, 1
	do
		toX[i] = 0;
		toY[i] = 0;

		eToX[i] = 0;
		eToY[i] = 0;
	end
end

function onBeatHit()

	if (mod == 1) then
		for i = 0, 3, 1
		do
			toX[i] = math.random(-50 * (3 - i), 20);

			if (downscroll) then
				toY[i] = math.random(-200, 20);
			else
				toY[i] = math.random(-20, 200);
			end
		end
	elseif (mod == 3) then
		for i = 0, 3, 1
		do
			toX[i] = 0;
			toY[i] = math.random(-60, 60);
		end
	end

	if (camMod == 0) then
		if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
		setProperty('camHUD.angle',angleshit*3)
		doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.008, 'circOut')
		doTweenX('tuin', 'camHUD', -angleshit*20, crochet*0.001, 'linear')
	end
end

function onStepHit()
	if (camMod == 0) then
		if curStep % 4 == 0 then
			doTweenY('rrr', 'camHUD', -12, stepCrochet*0.002, 'circOut')
		end
		if curStep % 4 == 2 then
			doTweenY('rir', 'camHUD', 0, stepCrochet*0.002, 'sineIn')
		end
	end
end

time = 0;
function onUpdate(elapsed)
	--esta mierda va aquí por alguna razón
	defX[0] = defaultPlayerStrumX0;
	defX[1] = defaultPlayerStrumX1;
	defX[2] = defaultPlayerStrumX2;
	defX[3] = defaultPlayerStrumX3;

	defY[0] = defaultPlayerStrumY0 + 10;
	defY[1] = defaultPlayerStrumY1 + 10;
	defY[2] = defaultPlayerStrumY2 + 10;
	defY[3] = defaultPlayerStrumY3 + 10;

	eDefX[0] = defaultOpponentStrumX0;
	eDefX[1] = defaultOpponentStrumX1;
	eDefX[2] = defaultOpponentStrumX2;
	eDefX[3] = defaultOpponentStrumX3;

	eDefY[0] = defaultOpponentStrumY0;
	eDefY[1] = defaultOpponentStrumY1;
	eDefY[2] = defaultOpponentStrumY2;
	eDefY[3] = defaultOpponentStrumY3;

	time = time + elapsed * 60;

	if (mod == -1) then
		for i = 0, 3, 1
		do
			toX[i] = 0;
			toY[i] = 0;
		end
	end

	if (camMod == -1) then
		setProperty('camHUD.angle', 0);
	end

	for i = 0, 3, 1
	do
		local prevX = getPropertyFromGroup('playerStrums', i, 'x');
		local realToX = defX[i] + toX[i];
		setPropertyFromGroup('playerStrums', i, 'x', prevX + (realToX - prevX) / (8 / (elapsed * 50)));

		local prevY = getPropertyFromGroup('playerStrums', i, 'y');
		local realToY = defY[i] + toY[i];
		setPropertyFromGroup('playerStrums', i, 'y', prevY + (realToY - prevY) / (8 / (elapsed * 50)));

		if (mirror) then
			prevX = getPropertyFromGroup('opponentStrums', i, 'x');
			realToX = eDefX[i] - toX[3 - i];
			setPropertyFromGroup('opponentStrums', i, 'x', prevX + (realToX - prevX) / (8 / (elapsed * 50)));

			prevY = getPropertyFromGroup('opponentStrums', i, 'y');
			realToY = defY[i] + toY[3 - i];
			setPropertyFromGroup('opponentStrums', i, 'y', prevY + (realToY - prevY) / (8 / (elapsed * 50)));
		end
	end

	--aparentemente no existe un switch en lua????
	if (mod == 0) then
		for i = 0, 3, 1
		do
			toX[i] = math.cos(time / 6 + i) * 20;
			toY[i] = math.sin(time / 6 + i) * 20;
		end
	elseif (mod == 2) then
		if (time % 4 > 2) then
			for i = 0, 3, 1
			do
				toX[i] = math.random(-200, 50);

				if (downscroll) then
					toY[i] = math.random(-200, 40);
				else
					toY[i] = math.random(-40, 200);
				end
			end
		end
	elseif (mod == 3) then
		for i = 0, 3, 1
		do
			toX[i] = math.cos(time / 3 + i) * 20;
		end
	elseif (mod == 4) then
		for i = 0, 3, 1
		do
			toX[i] = math.cos(time / 6 + i) * 40;
			toY[i] = math.sin(time / 3 + i) * 20;
		end
	end

	if (camMod == 1) then
		doTweenAngle('turn', 'camHUD', math.sin(time / 8) * 6, stepCrochet*0.002, 'linear');
	end
end

function onEvent(name, value1, value2)
	if name == 'modChange' then
		if (value1 ~= '') then
			mod = tonumber(value1);
		end

		if (value2 ~= '') then
			camMod = tonumber(value2);
		end
	end
end