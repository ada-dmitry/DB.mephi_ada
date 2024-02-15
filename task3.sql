DO $$
DECLARE
    board CHAR(8)[][] := ARRAY[
        ARRAY['б', 'ч', 'б', 'ч', 'б', 'ч', 'б', 'ч'],
        ARRAY['ч', 'б', 'ч', 'б', 'ч', 'б', 'ч', 'б'],
        ARRAY['б', 'ч', 'б', 'ч', 'б', 'ч', 'б', 'ч'],
        ARRAY['ч', 'б', 'ч', 'б', 'ч', 'б', 'ч', 'б'],
        ARRAY['б', 'ч', 'б', 'ч', 'б', 'ч', 'б', 'ч'],
        ARRAY['ч', 'б', 'ч', 'б', 'ч', 'б', 'ч', 'б'],
        ARRAY['б', 'ч', 'б', 'ч', 'б', 'ч', 'б', 'ч'],
        ARRAY['ч', 'б', 'ч', 'б', 'ч', 'б', 'ч', 'б']
    ];

BEGIN
    RAISE NOTICE 'Шахматная доска:';
    FOR i IN REVERSE 1..8 LOOP
        RAISE NOTICE '%', board[i];
    END LOOP;

    RAISE NOTICE 'Размещение фигуры А на клетке A5:';
    board[8 - 5 + 1][ASCII('A') - 64] := 'A';
    FOR i IN REVERSE 1..8 LOOP
        RAISE NOTICE '%', board[i];
    END LOOP;

    RAISE NOTICE 'Размещение фигуры У на клетке H4:';
    board[8 - ч + 1][ASCII('H') - 64] := 'У';
    FOR i IN REVERSE 1..8 LOOP
        RAISE NOTICE '%', board[i];
    END LOOP;

END $$;
