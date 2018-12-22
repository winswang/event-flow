function par = MyOptFlowEvPF(evim)
ev = evim.ev_bucket_scale{evim.flow_idx};

par.th1 = evim.th1;
par.th2 = evim.th2;
th1 = par.th1;
th2 = par.th2;
par.s_wid = evim.s_wid;
par.t_wid = evim.t_wid;
par.xytpv = [];
par.tscale_flag = 1;
plot_flag = 0;
for i = 1:size(ev,2)
    par.curr_t = ev(1,i);
    par.curr_x = ev(2,i);
    par.curr_y = ev(3,i);
    par.curr_p = ev(4,i);
    epsilon = 1e6;
    switch par.curr_p
        case 1
            neighbors = gatherNeighbors(ev,par);
%             figure;
%             scatter3(neighbors(:,1),neighbors(:,2),neighbors(:,3));

            if size(neighbors,1) >= 4
                
                abcd_col = fit3Dpinv(neighbors(:,1),neighbors(:,2),neighbors(:,3));
%                 plotLocalPlane(abcd_col,par,'interp');
                while epsilon > th1 && size(neighbors,1) >=4
                    errs = neighbors*abcd_col;
                    [err_val,errs_idx] = max(abs(errs));
                    if err_val < th2
                        break;
                    else
                        neighbors(errs_idx,:) = [];
                        vec = fit3Dpinv(neighbors(:,1),neighbors(:,2),neighbors(:,3));
                        epsilon = sum(abs(vec-abcd_col));
                        abcd_col = vec;
                    end
                end

            end
        case 0
            neighbors = gatherNeighbors(ev,par);
            
%             figure;
%             plotScatter(neighbors);
            if size(neighbors,1) >= 4
                
                abcd_col = fit3Dpinv(neighbors(:,1),neighbors(:,2),neighbors(:,3));
%                 plotLocalPlane(abcd_col,par,'interp');
                
                while epsilon > th1 && size(neighbors,1) >=4
                    errs = neighbors*abcd_col;
                    [err_val,errs_idx] = max(abs(errs));
                    if err_val < th2
                        break;
                    else
                        neighbors(errs_idx,:) = [];
                        vec = fit3Dpinv(neighbors(:,1),neighbors(:,2),neighbors(:,3));
                        epsilon = sum(abs(vec-abcd_col));
                        abcd_col = vec;
                    end
                end

            end
    end

    if epsilon <= th1 && size(neighbors,1) >=4
        temp_sum = abcd_col(1)^2 + abcd_col(2)^2;
        vx = -abcd_col(3)*abcd_col(1)/temp_sum*par.t_wid;
        vy = -abcd_col(3)*abcd_col(2)/temp_sum*par.t_wid;
        xytpv = [par.curr_x;par.curr_y;par.curr_t;par.curr_p;vx;vy;abcd_col(3)*par.t_wid];
        if abs(vx) <= 2*par.s_wid && abs(vy) <= 2*par.s_wid
            par.xytpv = cat(2,par.xytpv,xytpv);
            if plot_flag == 1
                figure;
                plotScatter(neighbors);
                plotLocalPlane(abcd_col,par,'interp');
                xlabel('x');
                ylabel('y');
                zlabel('t');

                hold on
                % plot normal
        %         n_norm = sqrt(abcd_col(1)^2+abcd_col(2)^2+abcd_col(3)^2);
        %         n1 = abcd_col(1)/n_norm;
        %         n2 = abcd_col(2)/n_norm;
        %         n3 = abcd_col(3)/n_norm;
        %         q1 = quiver3(xytpv(1),xytpv(2),xytpv(3),n1,n2,-n3);
        %         q1.Color = [228,192,44]/255;
        %         q1.AutoScale = 'off';
        %         hold on
        %         figure;
        %         q1 = quiver3(0,0,0,abcd_col(1),abcd_col(2),abcd_col(3));
        %         q1.Color = [44,192,228]/255;
        %         q1.AutoScale = 'off';
        %         hold on
        %         [xgrid_,ygrid_] = meshgrid(linspace(-50,50,20),linspace(-50,50,20));
        %         tgrid_ = -(0+abcd_col(1)*xgrid_+abcd_col(2)*ygrid_)/abcd_col(3);
        %         hold on
        %         s_ = surf(xgrid_,ygrid_,tgrid_);
        %         s_.EdgeColor = 'none';
        %         s_.FaceColor = 'interp';
        %         s_.FaceAlpha = 0.7;
                % plot gradient
                q2 = quiver3(xytpv(1),xytpv(2),xytpv(3),vx,vy,xytpv(7));
                q2.Color = 'k';
                q2.AutoScale = 'off';
                view(10,20);
            end
        end
    end
          
end
    

    function neighbors = gatherNeighbors(event,parameter)
        win_t = [parameter.curr_t - parameter.t_wid, parameter.curr_t + parameter.t_wid];
        win_x = [parameter.curr_x - parameter.s_wid, parameter.curr_x + parameter.s_wid];
        win_y = [parameter.curr_y - parameter.s_wid, parameter.curr_y + parameter.s_wid];
        neighbors = [];
        for j = 1:size(event,2)
            p = event(4,j);
            if p == parameter.curr_p
                t = event(1,j);
                if t >=win_t(1) && t <= win_t(2)
                    x = event(2,j);
                    if x >=win_x(1) && x <= win_x(2)
                        y = event(3,j);
                        if y >= win_y(1) && y <= win_y(2)
                            if ~exist('neighbors')
                                neighbors = [x,y,t,1];
                            else
                                neighbors = cat(1,neighbors,[x,y,t,1]);
                            end
                            
                        end
                    end
                end
            end
        end
        
    end

    function vec = fit3Dpinv(x,y,z,avg_flag)
        if nargin < 4
            avg_flag = 0;
        end
        if size(x,1) == 1
            x = x';
            y = y';
            z = z';
        end
        if size(x,1) <3
            error('at least 3 points are needed');
        end
        x_avg = mean(x);
        y_avg = mean(y);
        z_avg = mean(z);
        if avg_flag == 1
            
            x = x - x_avg;
            
            y = y - y_avg;
            
            z = z - z_avg;
        end
        A = cat(2,x,y,ones(size(x,1),1));
        abc = -pinv(A)*z;
        vec = [abc(1);abc(2);1;abc(3)];
    end

    function vec = fit3Dcramer(x,y,z,avg_flag)
        if nargin < 4
            avg_flag = 0;
        end
        if size(x,1) == 1
            x = x';
            y = y';
            z = z';
        end
        if size(x,1) <3
            error('at least 3 points are needed');
        end
        x_avg = mean(x);
        y_avg = mean(y);
        z_avg = mean(z);
        if avg_flag == 1
            
            x = x - x_avg;
            
            y = y - y_avg;
            
            z = z - z_avg;
        end
        A = cat(2,x,y,ones(size(x,1),1));
        AtA = A'*A;
        Atz = -A'*z;
        xx = AtA(1,1);
        xy = AtA(1,2);
        yy = AtA(2,2);
        xz = Atz(1);
        yz = Atz(2);
        D = xx*yy-xy*xy;
        a = -(yz*xy - xz*yy)/D;
        b = -(xy*xz - xx*xz)/D;
        % vec = pinv(AtA)*Atz
        c = -1;
        d = z_avg - a*x_avg - b*y_avg;
        vec = [a;b;c;d];

    end

    function vec = fit3Dsvd(x,y,z,avg_flag)
        if nargin < 4
            avg_flag = 0;
        end
        if size(x,1) == 1
            x = x';
            y = y';
            z = z';
        end
        if size(x,1) <3
            error('at least 3 points are needed');
        end
        x_avg = mean(x);
        y_avg = mean(y);
        z_avg = mean(z);
        if avg_flag == 1
            
            x = x - x_avg;
            
            y = y - y_avg;
            
            z = z - z_avg;
        end
        
        A = cat(2,x,y,z,ones(size(x,1),1));
        [S,U,V] = svd(A);
        vec = V(:,4);
    end

    function plotLocalPlane(abcd,parameter,facecolor)
        xmin = parameter.curr_x - parameter.s_wid-5;
        xmax = parameter.curr_x + parameter.s_wid+5;
        ymin = parameter.curr_y - parameter.s_wid-5;
        ymax = parameter.curr_y + parameter.s_wid+5;
        [xgrid,ygrid] = meshgrid(linspace(xmin,xmax,20),linspace(ymin,ymax,20));
        tgrid = -(abcd(4)+abcd(1)*xgrid+abcd(2)*ygrid)/abcd(3);
        hold on
        s = surf(xgrid,ygrid,tgrid);
        s.EdgeColor = 'none';
        s.FaceColor = facecolor;
        s.FaceAlpha = 0.7;
    end

    function plotScatter(xyt)
        hold on;
        s = scatter3(xyt(:,1),xyt(:,2),xyt(:,3),10,'filled');

    end
end