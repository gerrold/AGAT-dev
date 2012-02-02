d=dir;
mkdir('zmensene')
for c=3:size(d,1)
    if d(c).isdir == 0
      copyfile(d(c).name,['zmensene/' lower(d(c).name)]);
      disp(['kopirujem a premenuvavam' d(c).name])
    end
end
    