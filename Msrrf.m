% transltion of SRRF to Matlab


function [result, r2] = Mssrf(mimage)
if nargin<1
    mimage = loadTiff();
end
k=cubic;
for t=1:(size(mimage,3))
             [U, V]=gradient(mimage(:,:,t));
             U=conv2(U,k,'same');
             V=conv2(V,k,'same');
             dd(:,:,t)=divergence(U,V);
    %dd(:,:,t)=del2(mimage(:,:,t));
end

for t=1:(size(mimage,3))
             
             dd2(:,:,t)=lappl(mimage(:,:,t));
    %dd(:,:,t)=del2(mimage(:,:,t));
end


    result=-mean(mimage.*dd,3);
    r2=mean(mimage.*dd2,3);
    figure;
    imagesc(conv2(result,k,'same'));colormap hot,axis equal, axis off
end

function otherOld()


%     %//%//%//%//%//%//%//%//%///
%     %// Setup methods %//
%     %//%//%//%//%//%//%//%//%///

if nargin<1
    mimage = loadTiff();
end

kernel = setupSRRF(1,1,1,1,1,1,0,0,0,0,0,0,0,0,'Gradient')
    function kernel = setupSRRF(magnification, order, symmetryAxis,...
            spatialRadius, psfWidth, border,...
            doRadialitySquaring, renormalize, doIntegrateLagTimes,...
            radialityPositivityConstraint, doTemporalSubtraction,...
            doGradWeight, doIntensityWeighting, doGradSmoothing,...
            display)
        
        kernel.magnification = magnification;
        kernel.SRRForder = order;
        kernel.nRingCoordinates = symmetryAxis * 2;
        kernel.spatialRadius = (spatialRadius * kernel.magnification);
        kernel.gradRadius = psfWidth * kernel.magnification;
        
        kernel.border = border;
        
        
        kernel.doRadialitySquaring = doRadialitySquaring> 0;
        kernel.renormalize = renormalize>0;
        kernel.doIntegrateLagTimes = doIntegrateLagTimes> 0;
        kernel.radialityPositivityConstra = radialityPositivityConstraint> 0;
        kernel.doTemporalSubtraction = doTemporalSubtraction> 0;
        kernel.doGradWeight = doGradWeight> 0;
        kernel.doIntensityWeighting = doIntensityWeighting>0;
        
        if(doGradSmoothing)
            kernel.ParallelGRadius = 2;
            kernel.PerpendicularGRadius = 1;
            kernel.doGradSmooth = 1;
        else
            kernel.ParallelGRadius = 1;
            kernel.PerpendicularGRadius = 0;
            kernel.doGradSmooth = 0;
        end
        
        if (strcmp(display,"Gradient"))
            kernel.display = 1;
        else
            if (strcmp(display,"Gradient Ring Sum"))
                kernel.display = 2;
            else
                if (strcmp(display,"Intensity Interp"))
                    kernel.display = 3;
                    
                else
                    kernel.display = 0;
                end
            end
        end
        kernel.setupComplete = true;
    end

%     %//%//%//%//%//%//%//%//%//%//%///
%     %// Calculate methods %//
%     %//%//%//%//%//%//%//%//%//%//%//
    function    my   = calculate5(pixels,  width, height, shiftX, shiftY)
        my   = kernel.calculate(pixels, width, height, shiftX, shiftY);
    end

    function   mProcessor = calculate1(ims)
        nSlices = ims.getSize();
        mProcessor = calculate(ims, nSlices, nSlices);
    end

    function mProcessor = calculate3(ims, shiftX, shiftY)
        
        pixels = ImageStackToArray(ims);
        width = ims.getWidth();
        height = ims.getHeight();
        rcArray = calculate5(pixels, width, height, shiftX, shiftY);
        magnification = kernel.magnification;
        
        mProcessor =  Processor(width * magnification, height * magnification, rcArray);
    end



% class Kernel_SRRF extends NJKernel {
%
    function f= calculate5b(pixels, width, height, shiftX, shiftY)
        
        %%//setExecutionMode(EXECUTION_MODE.JTP);
        
        assert (setupComplete);
        
        %%// Input image properties
        this.width = width;
        this.height = height;
        this.widthHeight = width * height;
        this.nTimePoints = pixels.length / widthHeight;
        this.widthHeightTime = widthHeight * nTimePoints;
        
        %%// Radiality Image Properties
        this.widthM = width * magnification;
        this.heightM = height * magnification;
        this.widthHeightM = widthM * heightM;
        this.widthHeightMTime = widthHeightM * nTimePoints;
        this.borderM = border * magnification;
        this.widthMBorderless = widthM - borderM * 2;
        this.heightMBorderless = heightM - borderM * 2;
        this.widthHeightMBorderless = widthMBorderless * heightMBorderless;
        this.widthHeightMTimeBorderless = widthHeightMBorderless * nTimePoints;
        
        %%// Initialise Arrays
        this.pixels = pixels;
        this.GxArray = widthHeightTime;
        this.GyArray = widthHeightTime;
        this.radArray = widthHeightMTime;
        this.SRRFArray = widthHeightM;
        this.shiftX = shiftX;
        this.shiftY = shiftY;
        
        %%// Upload arrays
        setExplicit(true);
        autoChooseDeviceForNanoJ();
        
        %//System.out.println("About to upload at magnification "+magnification);
        %//System.out.println(Arrays.toString(shiftX));
        %//System.out.println(Arrays.toString(shiftY));
        
        buildRing();
        put(this.xRingCoordinates0);
        put(this.yRingCoordinates0);
        put(this.xRingCoordinates1);
        put(this.yRingCoordinates1);
        put(this.pixels);
        put(this.GxArray);
        put(this.GyArray);
        put(this.radArray);
        put(this.SRRFArray);
        put(this.shiftX);
        put(this.shiftY);
        
        %//System.out.println("upload Success");
        
        log.startTimer();
        
        log.msg(3, "Kernel_SRRF: calculating SRRF");
        
        if (doTemporalSubtraction == 1 && nTimePoints > 1)
            stepFlag = STEP_CALCULATE_TEMPORAL_SUBTRACTION;
            execute(widthHeight);
        end
        
        %// Step 1 - calculate Gx and Gy
        stepFlag = STEP_CALCULATE_GXGY;
        execute(widthHeightTime);
        
        %//System.out.println("Gradient Calc success");
        
        %// Step 2 - calculate Radiality
        stepFlag = STEP_CALCULATE_RADIALITY;
        execute(widthHeightMBorderless);
        
        %//System.out.println("Radiality Calc success");
        
        %// Step 3 - calculate temporal correlations
        stepFlag = STEP_CALCULATE_SRRF;
        execute(widthHeightMBorderless);
        
        %//System.out.println("SRRF Calc success");
        
        get(SRRFArray);
        
        %//System.out.println("Get Array success");
        %//this bit solves a really strange bug where sometimes aparapi returns an empty array, we try to see if we have
        %//a zero-filled array and if so we force a re-run on JTP
        if (getExecutionMode()~=EXECUTION_MODE.JTP)
            if(getSumValue(SRRFArray)==0)
                runOnceAsJTP();
                f= calculate5b(pixels, width, height, shiftX, shiftY);
            end
        end
        log.msg(3, "Kernel_SRRF: done");
        f=SRRFArray;
    end

%//%//%//%//%//%//%//%//%//%//
%// NON-CL METHODS %//
%//%//%//%//%//%//%//%//%//%//

    function buildRing()
        xRingCoordinates0 = zeros(nRingCoordinates,1);
        yRingCoordinates0 = zeros(nRingCoordinates,1);
        xRingCoordinates1 = zeros(nRingCoordinates,1);
        yRingCoordinates1 = zeros(nRingCoordinates,1);
        angleStep = (PI * 2) /   nRingCoordinates;
        for(angleIter = 0: nRingCoordinates)
            xRingCoordinates0(angleIter) = spatialRadius * cos(angleStep * angleIter);
            yRingCoordinates0(angleIter) = spatialRadius * sin(angleStep * angleIter);
            xRingCoordinates1(angleIter) = gradRadius * cos(angleStep * angleIter);
            yRingCoordinates1(angleIter) = gradRadius * sin(angleStep * angleIter);
        end
    end

%//%//%//%//%//%//%//%//
%// CL METHODS %//
%//%//%//%//%//%//%//%//
runn();
%@Override
function runn()
    for i=1:length(mimage)
        run(i);
    end
    
end

    function run(GlobalId)
%        if (stepFlag == STEP_CALCULATE_TEMPORAL_SUBTRACTION) 
[width,height,nTimePoints] = size(mimage);
calculateTemporalSubtraction(GlobalId,width,height,nTimePoints);
%        else
%            if (stepFlag == STEP_CALCULATE_GXGY) 
calculateGxGy();
%            else
%                if (stepFlag == STEP_CALCULATE_RADIALITY) 
calculateRadiality();
%                 else
%                     if (stepFlag == STEP_CALCULATE_SRRF) 
calculateSRRF();
%                     end
%                 end
%             end
%         end
        
        function calculateTemporalSubtraction(GlobalId,width,height,nTimePoints)
            pixelIdx = GlobalId;%getGlobalId();
            x = mod(pixelIdx, width);
            y = mod((pixelIdx / width) , height);
            
            for ( t=0:nTimePoints-2)
                pixels(getIdx3(x, y, t)) = abs(pixels(getIdx3(x, y, t)) - pixels(getIdx3(x, y, t+1)));
            end
            pixels(getIdx3(x, y, nTimePoints-1)) = pixels(getIdx3(x, y, nTimePoints-2));
        end
        
        function calculateGxGy()
            pixelIdx = getGlobalId();
            x = mod(pixelIdx, width);
            y = mod((pixelIdx / width) , height);
            t = pixelIdx / widthHeight;
            
            %// Calculate Gx GY
            u_calculateGxGy(x, y, t);
        end
        
        function calculateRadiality()
            
            %// Position variables in Radiality magnified space
            idx = getGlobalId();
            X = mod(idx , widthMBorderless) + borderM;
            Y = mod((idx / widthMBorderless) , heightMBorderless) + borderM;
            %// t = idx / widthHeightMBorderless;
            
            for( t = 0: nTimePoints)
                Xc = X + 0.5 + shiftX(t) * magnification;
                Yc = Y + 0.5 + shiftY(t) * magnification;
                
                %// Gradient Variables
                GMag=0, GMag1=0, GMagSum1 = 0;
                GdotR = 0, GdotR1 = 0;
                
                %// Radiality Variables
                Dk=0, DivDFactor = 0;
                
                %// Calculate Gradient at center
                GMagCenter = 0;
                IWCenter = 0;
                if (doGradWeight == 1 || display ~= 0)
                    Gx1 = u_interpolateGxGy(Xc, Yc, t, true);
                    Gy1 = u_interpolateGxGy(Xc, Yc, t, false);
                    GMagCenter = sqrt(Gx1.^2 + Gy1.^2);
                    IWCenter = u_interpolateIntensity(Xc, Yc, t);
                end
                
                %// Output
                CGH = 0;
                
                for ( sampleIter = 0:nRingCoordinates)
                    
                    isDiverging = -1;
                    isDiverging1 = -1;
                    
                    %// Sample (x, y) position
                    x0 = Xc + xRingCoordinates0(sampleIter);
                    y0 = Yc + yRingCoordinates0(sampleIter);
                    
                    Gx = u_interpolateGxGy(x0, y0, t, true);
                    Gy = u_interpolateGxGy(x0, y0, t, false);
                    GMag = sqrt(Gx * Gx + Gy * Gy);
                    GdotR = (Gx * xRingCoordinates0(sampleIter) + Gy * yRingCoordinates0(sampleIter)) / (GMag * spatialRadius);
                    
                    if (GdotR > 0 || GdotR ~= GdotR) isDiverging = 1;end
                    
                    if(doGradWeight == 1 || display == 2)
                        x1 = Xc + xRingCoordinates1(sampleIter);
                        y1 = Yc + yRingCoordinates1(sampleIter);
                        Gx1 = u_interpolateGxGy(x1, y1, t, true);
                        Gy1 = u_interpolateGxGy(x1, y1, t, false);
                        GMag1 = sqrt(Gx1 * Gx1 + Gy1 * Gy1);
                        GdotR1 = (Gx * xRingCoordinates1(sampleIter) + Gy * yRingCoordinates1(sampleIter)) / (GMag1 * gradRadius);
                        if (GdotR1 > 0 || GdotR1 ~= GdotR1)
                            isDiverging1 = 1;
                        end
                        if (isDiverging1 == 1)
                            GMagSum1 =GMagSum1 -( GMag1 - GMagCenter);
                        else
                            GMagSum1 = GMagSum1+ GMag1 - GMagCenter;
                        end
                        %//GMagSum1 += _calculateGradientMagnitude(x1, y1, t) - GMagCenter;
                    end
                    
                    %// Perpendicular distance from (Xc,Yc) to gradient line through (x,y)
                    Dk = 1 - u_calculateDk(x0, y0, Xc, Yc, Gx, Gy, GMag)/spatialRadius;
                    
                    %//                if (doRadialitySquaring == 1) {
                    %//                    Dk = Dk * Dk;
                    %//                end
                    Dk = Dk * Dk;
                    
                    %// Accumulate Variables
                    if (isDiverging == 1)
                        DivDFactor =DivDFactor - Dk;
                    else
                        DivDFactor =DivDFactor + Dk;
                    end
                    
                end
                DivDFactor = DivDFactor / nRingCoordinates;
                
                if(renormalize == 1)
                    DivDFactor = 0.5 + (DivDFactor / 2);
                end
                
                if (radialityPositivityConstra == 1)
                    CGH = max(DivDFactor, 0);
                else
                    CGH = DivDFactor;
                end
                
                if (doGradWeight == 1 || display == 2)
                    if (radialityPositivityConstra == 1)
                        GMagSum1 = max(GMagSum1, 0);
                    end
                    GMagSum1 = GMagSum1 / nRingCoordinates;
                    GMagSum1 = GMagSum1 / max(IWCenter,1);
                    CGH = CGH * GMagSum1;
                end
                
                radArray(getIdxRM3(X, Y, t)) = CGH;
                if (display == 1)
                    radArray(getIdxRM3(X, Y, t)) = GMagCenter;
                else
                    if (display == 2)
                        radArray(getIdxRM3(X, Y, t)) = GMagSum1;
                    else
                        if(display == 3)
                            radArray(getIdxRM3(X, Y, t)) = IWCenter;
                        end
                    end
                end
                
            end
        end
        
        function calculateSRRF()
            if (SRRForder == -1)
                u_calculatePairwiseProductSum();
                
            else
                if(SRRForder == 0)
                    u_calculateMIP();
                else
                    if(SRRForder == 1)
                        u_calculateAVE();
                    else
                        u_calculateACRF();
                    end
                end
            end
        end
        
        function u_calculateMIP()
            idx = getGlobalId();
            x = mod(idx , widthMBorderless) + borderM;
            y = mod((idx / widthMBorderless) , heightMBorderless) + borderM;
            
            
            MIP = 0;
            
            if (doIntensityWeighting == 1)
                for (t=0:nTimePoints)
                    u_x =   x + 0.5 + shiftX(t) * magnification;
                    u_y =   y + 0.5 + shiftY(t) * magnification;
                    MIP = max(radArray(getIdxRM3(x, y, t)) * u_interpolateIntensity(u_x, u_y, t),MIP);
                end
            else
                for (t = 0:nTimePoints)
                    MIP = max(radArray(getIdxRM3(x, y, t)), MIP);
                end
            end
            
            SRRFArray(y * widthM + x) = MIP;
        end
        
        function u_calculatePairwiseProductSum()
            idx = getGlobalId();
            x = mod(idx , widthMBorderless) + borderM;
            y = mod(idx / widthMBorderless , heightMBorderless) + borderM;
            
            
            pps = 0; r0 = 0; r1 = 0;
            IW = 0;
            counter = 0;
            
            
            for (t0 = 0:nTimePoints)
                r0 = max(radArray(getIdxRM3(x, y, t0)), 0);
                if (r0 > 0)
                    for ( t1 = t0:nTimePoints)
                        r1 = max(radArray(getIdxRM3(x, y, t1)), 0);
                        pps = pps + r0 * r1;
                        counter=counter+1;
                    end
                else
                    counter = counter  +nTimePoints - t0;
                end
            end
            pps =pps / max(counter, 1);
            
            
            if (doIntensityWeighting == 1)
                for (t = 0:nTimePoints)
                    u_x =   x + 0.5 + shiftX(t) * magnification;
                    u_y =   y + 0.5 + shiftY(t) * magnification;
                    IW =IW + u_interpolateIntensity(u_x, u_y, t) / nTimePoints;
                end
                pps =pps* IW;
            end
            
            SRRFArray(y * widthM + x) = pps;
        end
        
        function u_calculateAVE()
            idx = getGlobalId();
            x = mod(idx , widthMBorderless) + borderM;
            y = mod((idx / widthMBorderless) , heightMBorderless) + borderM;
            
            u_x;
            u_y;
            
            mean = 0;
            
            if (doIntensityWeighting == 1)
                for (t=0:nTimePoints)
                    u_x =   x + 0.5 + shiftX(t) * magnification;
                    u_y =   y + 0.5 + shiftY(t) * magnification;
                    mean = mean + radArray(getIdxRM3(x, y, t)) * u_interpolateIntensity(u_x, u_y, t);
                end
            else
                for (t = 0:nTimePoints)
                    mean = mean + radArray(getIdxRM3(x, y, t));
                end
            end
            mean = mean / nTimePoints;
            
            SRRFArray(y * widthM + x) = mean;
        end
        
        function u_calculateACRF()
            idx = getGlobalId();
            x = mod(idx, widthMBorderless) + borderM;
            y = mod((idx / widthMBorderless) , heightMBorderless) + borderM;
            
            u_x;
            u_y;
            
            mean = 0;
            IW = 0;
            t = 0;
            tBin = 0;
            nBinnedTimePoints = nTimePoints;
            ABCD = 0;
            ABC = 0;
            AB = 0;
            CD = 0;
            AC = 0;
            BD = 0;
            AD = 0;
            BC = 0;
            A = 0;
            B = 0;
            C = 0;
            D = 0;
            
            for (ti=0:nTimePoints)
                u_x =   x + 0.5 + shiftX(ti) * magnification;
                u_y =   y + 0.5 + shiftY(ti) * magnification;
                IW =IW + radArray(getIdxRM3(x, y, ti)) * u_interpolateIntensity(u_x, u_y, ti);
                mean =mean+ radArray(getIdxRM3(x, y, ti));
            end
            mean = mean / nTimePoints;
            IW = IW / nTimePoints;
            
            
            if(doIntegrateLagTimes ~= 1)
                t = 0;
                ABCD = 0;
                ABC = 0;
                AB = 0;
                CD = 0;
                AC = 0;
                BD = 0;
                AD = 0;
                BC = 0;
                while (t < (nTimePoints - SRRForder))
                    AB =AB + ((radArray(getIdxRM3(x, y, t)) - mean) * (radArray(getIdxRM3(x, y, t + 1)) - mean));
                    if (SRRForder == 3)
                        ABC =ABC + ((radArray(getIdxRM3(x, y, t)) - mean) * (radArray(getIdxRM3(x, y, t + 1)) - mean) * (radArray(getIdxRM3(x, y, t + 2)) - mean));
                    end
                    if (SRRForder == 4)
                        A = radArray(getIdxRM3(x, y, t)) - mean;
                        B = radArray(getIdxRM3(x, y, t + 1)) - mean;
                        C = radArray(getIdxRM3(x, y, t + 2)) - mean;
                        D = radArray(getIdxRM3(x, y, t + 3)) - mean;
                        ABCD =ABCD + A * B * C * D;
                        CD =CD + C * D;
                        AC =AC + A * C;
                        BD =BD + B * D;
                        AD =AD + A * D;
                        BC =BC + B * C;
                    end
                    t=t+1;
                end
                if (SRRForder == 3)
                    SRRFArray(y * widthM + x) = abs(ABC) /   nTimePoints;
                else
                    if (SRRForder == 4)
                        SRRFArray(y * widthM + x) = abs(ABCD - AB * CD - AC * BD - AD * BC) /   nTimePoints;
                    else
                        SRRFArray(y * widthM + x) = abs(AB) /   nTimePoints;
                    end
                end
            else
                
                while (nBinnedTimePoints > SRRForder)
                    t = 0;
                    AB = 0;
                    
                    while (t < (nBinnedTimePoints - SRRForder))
                        tBin = t * SRRForder;
                        AB =AB + ((radArray(getIdxRM3(x, y, t)) - mean) * (radArray(getIdxRM3(x, y, t + 1)) - mean));
                        if (SRRForder == 3)
                            ABC =ABC + ((radArray(getIdxRM3(x, y, t)) - mean) * (radArray(getIdxRM3(x, y, t + 1)) - mean) * (radArray(getIdxRM3(x, y, t + 2)) - mean));
                        end
                        if (SRRForder == 4)
                            A = radArray(getIdxRM3(x, y, t)) - mean;
                            B = radArray(getIdxRM3(x, y, t + 1)) - mean;
                            C = radArray(getIdxRM3(x, y, t + 2)) - mean;
                            D = radArray(getIdxRM3(x, y, t + 3)) - mean;
                            ABCD=ABCD+ A * B * C * D;
                            CD =CD+ C * D;
                            AC =AC+ A * C;
                            BD =BD+ B * D;
                            AD =AD+ A * D;
                            BC =BC+ B * C;
                        end
                        radArray(getIdxRM3(x, y, t)) = 0;
                        if (tBin < nBinnedTimePoints)
                            for(u_t = 0:SRRForder)
                                radArray(getIdxRM3(x, y, t)) =radArray(getIdxRM3(x, y, t))+ radArray(getIdxRM3(x,y,tBin+u_t)) /   SRRForder;
                            end
                        end
                        t=+1;
                    end
                    if (SRRForder == 3)
                        SRRFArray(y * widthM + x) =SRRFArray(y * widthM + x)+ abs(ABC) / nBinnedTimePoints;
                    else
                        if (SRRForder == 4)
                            SRRFArray(y * widthM + x) =SRRFArray(y * widthM + x)+ abs((ABCD - AB * CD - AC * BD - AD * BC)) / nBinnedTimePoints;
                        else
                            SRRFArray(y * widthM + x) =SRRFArray(y * widthM + x)+ abs(AB) /   nBinnedTimePoints;
                        end
                    end
                    nBinnedTimePoints = nBinnedTimePoints / SRRForder;
                end
            end
            if (doIntensityWeighting == 1)
                SRRFArray(y * widthM + x) = IW * SRRFArray(y * widthM + x);
            end
        end
        
        %//%//%//%//%//%//%//%//%//%//
        %// Helper Methods %//
        %//%//%//%//%//%//%//%//%//%//
        
        function ff = u_calculateDk(  x,   y,   Xc,   Yc,   Gx,   Gy,   Gx2Gy2)
            Dk = abs(Gy * (Xc - x) - Gx * (Yc - y)) / Gx2Gy2;
            if (Dk == Dk)
                ff=Dk;
            else
                ff=1 * spatialRadius;
            end
        end
        
        function u_calculateGxGy( x,  y,  t)
            
            %//boundary checked x - y pixel co-ords
            
            if (doGradSmooth == 0)
                x0 = max(x-1, 0);
                x1 = min(x+1, width-1);
                y0 = max(y-1, 0);
                y1 = min(y+1, height-1);
                GxArray(getIdx3(x, y, t)) = -pixels(getIdx3(x0, y, t))+pixels(getIdx3(x1, y, t));
                GyArray(getIdx3(x, y, t)) = -pixels(getIdx3(x, y0, t))+pixels(getIdx3(x, y1, t));
                return;
            end
            
            %// Calculate Gx or Gy
            v = 0;
            for ( i = -ParallelGRadius:ParallelGRadius)
                for ( j = -PerpendicularGRadius:PerpendicularGRadius)
                    x_ = min(max((x + i), 0), width - 1);
                    y_ = min(max((y + j), 0), height - 1);
                    if (i < 0)
                        v =v - pixels(getIdx3(x_, y_, t));
                    else
                        if (i > 0)
                            v =v + pixels(getIdx3(x_, y_, t));
                        end
                    end
                end
            end
            GxArray(getIdx3(x, y, t)) = v;
            
            v = 0;
            for ( i = -PerpendicularGRadius: PerpendicularGRadius)
                for ( j = -ParallelGRadius:ParallelGRadius)
                    x_ = min(max((x + i), 0), width - 1);
                    y_ = min(max((y + j), 0), height - 1);
                    if (j < 0)
                        v =v- pixels(getIdx3(x_, y_, t));
                    else
                        if (j > 0)
                            v =v+ pixels(getIdx3(x_, y_, t));
                        end
                    end
                end
            end
            GyArray(getIdx3(x, y, t)) = v;
            
        end
        
        function g = u_interpolateGxGy(  x,   y,  t, isGx)
            
            x = x / magnification;
            y = y / magnification;
            
            if (x<1.5 || x>width-1.5 || y<1.5 || y>height-1.5)
                g= 0;
            else
                if(isGx)
                    u0 =   floor(x - 0.5);
                    v0 =   floor(y - 0.5);
                    q = 0.0;
                    for ( j = 0:3)
                        v = v0 - 1 + j;
                        p = 0.0;
                        for ( i = 0:3)
                            u = u0 - 1 + i;
                            p = p + GxArray(getIdx3(u, v, t)) * cubic(x - (u + 0.5));
                        end
                        q = q + p * cubic(y - (v + 0.5));
                    end
                    g= q;
                else
                    u0 =   floor(x - 0.5);
                    v0 =   floor(y - 0.5);
                    q = 0.0;
                    for ( j = 0:3)
                        v = v0 - 1 + j;
                        p = 0.0;
                        for (i = 0:3)
                            u = u0 - 1 + i;
                            p = p + GyArray(getIdx3(u, v, t)) * cubic(x - (u + 0.5));
                        end
                        q = q + p * cubic(y - (v + 0.5));
                    end
                    g= q;
                end
            end
        end
        
        function m = u_interpolateIntensity(  x,   y,  t)
            x = x / magnification;
            y = y / magnification;
            
            if (x<1.5 || x>width-1.5 || y<1.5 || y>height-1.5)
                m =  0;
            else
                u0 = floor(x - 0.5);
                v0 = floor(y - 0.5);
                q = 0.0;
                for (j = 0:3)
                    v = v0 - 1 + j;
                    p = 0.0;
                    for ( i = 0:3 )
                        u = u0 - 1 + i;
                        p = p + pixels(getIdx3(u, v, t)) * cubic(x - (u + 0.5));
                    end
                    q = q + p * cubic(y - (v + 0.5));
                end
                m  =  max(q, 0.0);
            end
        end
        
        function mz = cubic(  x)
            a = 0.5; %// Catmull-Rom interpolation
            if (x < 0.0) x = -x;end
            z = 0.0;
            if (x < 1.0)
                z = x * x * (x * (-a + 2.0) + (a - 3.0)) + 1.0;
            else
                if (x < 2.0)
                    z = -a * x * x * x + 5.0 * a * x * x - 8.0 * a * x + 4.0 * a;
                end
            end
            mz =z;
        end
        
        %//%//%//%//%//%//%//%//%//%//%///
        %// Get Array Indexes %//
        %//%//%//%//%//%//%//%//%//%//%///
        
        function mint = getIdx3( x,  y, t)
            pt = t * widthHeight;
            pf = y * width + x; %// position within a frame
            mint =pt + pf;
        end
        
        function m = getIdxRM3( x,  y,  t)
            ptRM = t * widthHeightM;
            pfRM = y * widthM + x;
            m  =ptRM + pfRM;
        end
    end
end