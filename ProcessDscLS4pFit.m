function ProcessDscLS4pFit(dsc,reason)
% @fn ProcessDscLS4pFit
% @brief Processes measurement descriptor using 4-parameter fit in least
%        squares sense
% @param dsc The measurement descriptor to process
% @param reason The reason of 4 parameter fit:
%                   case 'LS4p_only': to calculate residuals and ENOB
%                   otherwise: to get initial estimator for ML fit
% @return none
% @author Tam�s Virosztek, Budapest University of Technology and Economics,
%         Department of Measurement and Infromation Systems,
%         Virosztek.Tamas@mit.bme.hu

screensize = get(0,'ScreenSize');

if strcmpi(reason,'LS4p_only')
    window_title = 'Four parameter LS sine wave fit';
else
    window_title = 'ML parameter estimation: getting initial estimators';
end

%initializing state variables:
%Method of optimization
method = 'AnnexB'; %IEEE-1241-2010 Annex B
source_of_initial_fr = 'FFT';
initial_fr_value = 1e-2;


%Parameters of optimization:
first_sample = 1; %First/last sample options are bypassed here
last_sample = length(dsc.data);
amplim_min = 1; %Amplim is bypassed here 
amplim_max = 2^dsc.NoB - 2;
options = optimset();

ls_fit_window = figure ('Name',window_title,...
                        'Position',[screensize(3)*0.25 screensize(4)*0.25 screensize(3)*0.5 screensize(4)*0.5],...
                        'NumberTitle','off');

hTextFirstSample = uicontrol('Style','text',...
                             'Units','normalized',...
                             'Position',[0.2 0.38 0.2 0.04],...
                             'String','First used sample of record: ',...
                             'HorizontalAlignment','left',...
                             'BackgroundColor',[0.8 0.8 0.8]);
                      
hEditFirstSample = uicontrol('Style','edit',...
                              'Units','normalized',...
                              'Position',[0.42 0.38 0.06 0.05],...
                              'String',sprintf('%d',first_sample),...
                              'HorizontalAlignment','right',...
                              'Callback',@EditFirstSample_callback);
                          
hTextLastSample = uicontrol('Style','text',...
                             'Units','normalized',...
                             'Position',[0.5 0.38 0.2 0.04],...
                             'String','Last used sample of record: ',...
                             'HorizontalAlignment','left',...
                             'BackgroundColor',[0.8 0.8 0.8]);
                          
hEditLastSample = uicontrol ('Style','edit',...
                             'Units','normalized',...
                             'Position',[0.72 0.38 0.06 0.05],...
                             'String',sprintf('%d',last_sample),...
                             'HorizontalAlignment','right',...                             
                             'Callback',@EditLastSample_callback);
                         
hTextAmpLimMax = uicontrol('Style','text',...
                             'Units','normalized',...
                             'Position',[0.2 0.3 0.2 0.04],...
                             'String','Upper limit (ADC code): ',...
                             'HorizontalAlignment','left',...
                             'BackgroundColor',[0.8 0.8 0.8]);
                         
hEditAmpLimMax = uicontrol   ('Style','edit',...
                              'Units','normalized',...
                              'Position',[0.42 0.3 0.06 0.05],...
                              'String',sprintf('%d',amplim_max),...
                              'HorizontalAlignment','right',...                              
                              'Callback',@EditAmpLimMax_callback);
                         
hTextAmpLimMin = uicontrol('Style','text',...
                             'Units','normalized',...
                             'Position',[0.5 0.3 0.2 0.04],...
                             'String','Lower limit (ADC code): ',...
                             'HorizontalAlignment','left',...
                             'BackgroundColor',[0.8 0.8 0.8]);

hEditAmpLimMin = uicontrol   ('Style','edit',...
                              'Units','normalized',...
                              'Position',[0.72 0.3 0.06 0.05],...
                              'String',sprintf('%d',amplim_min),...
                              'HorizontalAlignment','right',...                              
                              'Callback',@EditAmpLimMin_callback);

                        
hTextAdvancedSettings = uicontrol('Style','text',...
                                 'Units','normalized',...
                                 'Position',[0.35 0.93 0.3 0.05],...
                                 'String','Advanced settings of LS fit',...
                                 'BackgroundColor',[0.8 0.8 0.8],...
                                 'FontWeight','bold');                                 
                             
hTextSelectMethod = uicontrol('Style','text',...
                              'Units','normalized',...
                              'Position',[0.2 0.85 0.2 0.04],...
                              'String','Method: ',...
                              'HorizontalAlignment','left',...                                                           
                              'BackgroundColor',[0.8 0.8 0.8]);
                             
hPopupSelectMethod = uicontrol('Style','popup',...
                               'Units','normalized',...
                               'Position',[0.4 0.85 0.4 0.05],...
                               'String',{'IEEE-1241-2010 Annex B','LsqNonlin'},...
                               'Callback',@SelectMethod_callback);

hTextMaxIter = uicontrol('Style','text',...
                         'Units','normalized',...
                         'Position',[0.2 0.77 0.4 0.04],...
                         'String','Max. number of iterations: ',...
                         'HorizontalAlignment','left',...
                         'BackgroundColor',[0.8 0.8 0.8]);
                          
hEditMaxIter = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'Position', [0.6 0.77 0.2 0.05],...
                         'String','Default',...
                         'Enable','off',...
                         'Callback',@EditMaxIter_callback);
                           
hTextMaxFunEvals = uicontrol('Style','text',...
                             'Units','normalized',...
                             'Position',[0.2 0.69 0.4 0.04],...
                             'String','Max. number of function evaluations: ',...
                             'HorizontalAlignment','left',...                             
                             'BackgroundColor',[0.8 0.8 0.8]);

hEditMaxFunEvals = uicontrol('Style','edit',...
                             'Units','normalized',...
                             'Position', [0.6 0.69 0.2 0.05],...
                             'String','Default',...
                             'Enable','off',...
                             'Callback',@EditMaxFunEvals_callback);

hTextTolFun = uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[0.2 0.62 0.4 0.04],...
                        'String','Termination tolerance on cost function',...
                        'HorizontalAlignment','left',...                             
                        'BackgroundColor',[0.8 0.8 0.8]);
                        
hEditTolFun = uicontrol('Style','edit',...
                        'Units','normalized',...
                        'Position', [0.6 0.62 0.2 0.05],...
                        'String','Default',...
                        'Enable','off',...
                        'Callback',@EditTolFun_callback);
                    
hTextSourceOfInitFr =  uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[0.2 0.54 0.3 0.04],...
                        'String','Source of initial frequency estimator: ',...
                        'HorizontalAlignment','left',...                             
                        'BackgroundColor',[0.8 0.8 0.8]);
                    
hPopupSourceOfInitFr = uicontrol('Style','popup',...
                               'Units','normalized',...
                               'Position',[0.5 0.54 0.3 0.05],...
                               'String',{'FFT','ipFFT (without windowing)','ipFFT (Hann window)','ipFFT (Blackman window)','User-specified'},...
                               'Callback',@SourceOfInitFr_callback);
                           
hTextInitialFrValue = uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[0.2 0.46 0.4 0.04],...
                        'String','Value of initial frequency estimator (f/fs): ',...
                        'HorizontalAlignment','left',...                             
                        'BackgroundColor',[0.8 0.8 0.8]);                          

hEditInitialFrValue = uicontrol('Style','edit',...
                                'Units','normalized',...
                                'Position',[0.6 0.46 0.2 0.04],...
                                'String','1e-2',...
                                'HorizontalAlignment','right',...
                                'Enable','off',...
                                'Callback',@InitialFrValue_callback);
                    
if strcmpi(reason,'LS4p_only')
    hPushButtonProcess = uicontrol ('Style','pushbutton',...
                                 'String','Perform LS fit and show results',...
                                 'Units','normalized',...
                                 'Position',[0.3 0.1 0.4 0.1],...
                                 'Callback',@ProcessAndShowResults_callback);
else
    hPushButtonProcess =  uicontrol ('Style','pushbutton',...
                                 'String','Get initial estimators and perform ML fit',...
                                 'Units','normalized',...
                                 'Position',[0.3 0.1 0.4 0.1],...
                                 'Callback',@ProcessAndPerformML_callback);
end
                                                                  

    function EditFirstSample_callback(source,eventdata)
        first_sample = str2double(get(source,'String'));
    end
    
    function EditLastSample_callback(source,eventdata)
        last_sample = str2double(get(source,'String'));
    end

    function EditAmpLimMax_callback(source,eventdata)
        amplim_max = str2double(get(source,'String'));
    end

    function EditAmpLimMin_callback(source,eventdata)
        amplim_min = str2double(get(source,'String'));
    end

    function SelectMethod_callback(source,eventdata)
        if (get(source,'Value') == 1) %IEEE-1241-2010 Annex B
            method = 'AnnexB';
            UpdateDisplay;
        elseif (get(source,'Value') == 2) %Lsqnonlin with Levenberg-Marquardt step
            method = 'LsqNonlin';
            options.LevenbergMaquardt = 'on';
            UpdateDisplay;
        else
        end
    end

    function EditMaxIter_callback(source,eventdata)
        if strcmpi(get(source,'String'),'Default')
            options.MaxIter = [];
        else
            options.MaxIter = str2double(get(source,'String'));
        end
    end

    function EditMaxFunEvals_callback(source,eventdata)
        if strcmpi(get(source,'String'),'Default')
            options.MaxFunEvals = [];
        else
            options.MaxFunEvals = str2double(get(source,'String'));
        end
    end

    function EditTolFun_callback(source,eventdata)
        if strcmpi(get(source,'String'),'Default')
            options.TolFun = [];
        else
            options.TolFun = str2double(get(source,'String'));
        end        
    end

    function SourceOfInitFr_callback(source,eventdata)
        popup_strings = get(source,'String');
        source_of_initial_fr = popup_strings{get(source,'Value')};
        UpdateDisplay;
    end

    function InitialFrValue_callback(source,eventdata)
        initial_fr_value = str2double(get(source,'String'));
    end


    function ProcessAndShowResults_callback(source,eventdata)
        %Pre-processing data
        [datavect,timevect,initial_freq,reduced_data,M] = PreProcessData(first_sample,last_sample,amplim_min,amplim_max,dsc,source_of_initial_fr);  
        %In case of user-specified initial frequency estimator        
        if strcmpi(source_of_initial_fr,'User-specified') 
            initial_freq = initial_fr_value;
        end
                
        %Fitting sine wave 4p LS sense
        if strcmpi(method,'AnnexB')
            [X] = sfit4imp(datavect,timevect,1,initial_freq,'No'); %Initial frequency is given relative to the sample rate
            p = zeros(4,1);
            p(1) = X.A*cos(X.phi/180*pi) ;
            p(2) = (-1)*X.A*sin(X.phi/180*pi);
            p(3) = X.DC;
            p(4) = 2*pi*X.f;
            fitted_sinewave = (p(1)*cos((1:M).'*p(4)) + p(2)*sin((1:M).'*p(4)) + p(3));
            residuals = fitted_sinewave(timevect) - datavect;            
        else
            p = SineWaveFit4pLsqNonlin(datavect,timevect,initial_freq,options);
            fitted_sinewave = (p(1)*cos((1:M).'*p(4)) + p(2)*sin((1:M).'*p(4)) + p(3));
            residuals = fitted_sinewave(timevect) - datavect;
        end

        %Displaying results
        DisplayResultsLS4p(p,residuals,timevect,dsc.NoB,dsc);
    end

    function ProcessAndPerformML_callback(source,eventdata)
        %Pre-processing data
        [datavect,timevect,initial_freq,reduced_data,M] = PreProcessData(first_sample,last_sample,amplim_min,amplim_max,dsc,source_of_initial_fr);  
        %In case of user-specified initial frequency estimator        
        if strcmpi(source_of_initial_fr,'User-specified') 
            initial_freq = initial_fr_value;
        end
       
        %Fitting sine wave 4p LS sense
        if strcmpi(method,'AnnexB')
            [X] = sfit4imp(datavect,timevect,1,initial_freq,'No'); %Initial frequency is given relative to the sample rate
            p = zeros(4,1);
            p(1) = X.A*cos(X.phi/180*pi);
            p(2) = (-1)*X.A*sin(X.phi/180*pi);
            p(3) = X.DC;
            p(4) = 2*pi*X.f;
        else            
            p = SineWaveFit4pLsqNonlin(datavect,timevect,initial_freq,options);
        end
        ProcessDscML5pFit(dsc,reduced_data,timevect,p);        
    end

        function [datavect,timevect,initial_freq,reduced_data,M] = PreProcessData(first_sample,last_sample,amplim_min,amplim_max,dsc,source_of_initial_fr)            
            %Getting initial frequency estimator:
            NFFT = 1e6;
            reduced_data = dsc.data(first_sample:last_sample);            
            initial_freq = EstimateFreqBH3Ipfft(reduced_data,NFFT,source_of_initial_fr);

            %Discarding samples according to amplitude limits:
            M = length(reduced_data);            
            timevect = zeros(M,1);
            l = 1;
            for k = 1:M
                if (reduced_data(k) <= amplim_max) && (reduced_data(k) >= amplim_min)
                    timevect(l) = k;
                    l = l + 1;
                end
            end                    
            timevect = timevect(1:l-1);
            datavect = reduced_data(timevect);
            %Forcing column vectors
            timevect = timevect(:);
            datavect = datavect(:);
        end

    function UpdateDisplay
        if strcmpi (method,'AnnexB')
            set(hEditMaxIter,'Enable','off');
            set(hEditMaxFunEvals,'Enable','off');
            set(hEditTolFun,'Enable','off');            
        else
            set(hEditMaxIter,'Enable','on');
            set(hEditMaxFunEvals,'Enable','on');
            set(hEditTolFun,'Enable','on');            
        end
            popup_strings = get(hPopupSourceOfInitFr,'String'); %Souce of initial frequency estimator
            if strcmpi(popup_strings{get(hPopupSourceOfInitFr,'Value')},'User-specified')
                set(hEditInitialFrValue,'Enable','on');
            else
                set(hEditInitialFrValue,'Enable','off');
            end
        
    end
end